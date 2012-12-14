Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2LNTgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:36:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab2LNTf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:35:59 -0500
Date: Fri, 14 Dec 2012 14:35:53 -0500
From: Dave Jones <davej@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
Message-ID: <20121214193553.GA2835@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 01:42:00PM -0500, Dave Hansen wrote:
 > I think the "Kernel Hacking" menu has gotten a bit out of hand.  It
 > is over 120 lines long on my system with everything enabled and
 > options are scattered around it haphazardly.
 > 
 > 	http://sr71.net/~dave/linux/kconfig-horror.png
 > 
 > Let's try to introduce some sanity.

Nice.  Perhaps as a follow-on patch, split up the Kconfig.debug into
a handful of files too ?

Thinking it might help prevent things getting so messed up again
when people start adding more options.

	Dave

