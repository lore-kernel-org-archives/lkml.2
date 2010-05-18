Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab0ERRHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab0ERRHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:07:11 -0400
Message-ID: <4BF2C91A.8000101@redhat.com>
Date: Tue, 18 May 2010 14:06:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
References: <4BF18995.6070008@redhat.com>
In-Reply-To: <4BF18995.6070008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current i7core_edac driver is ready for merge upstream, using the current
edac API. It supports the following processor families:
	i7core, i5core, Lynnfield, Nehalem, Nehalem-EP and Westmere-EP

The tree is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git linux_next

This driver doesn't support Nehalem-EX. From the discussions we had during
the mini-summit, the MCU of -EX family is very different, so, a separate
driver will be required for it.

Please review. My plan is to submit this driver for upstream merge this week.

-- 

Cheers,
Mauro
