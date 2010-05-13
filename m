Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab0EMS6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:58:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:2524 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab0EMS6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:58:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
Date: Thu, 13 May 2010 12:58:01 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>
References: <4BEAF008.9030805@sgi.com>
In-Reply-To: <4BEAF008.9030805@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005131258.01649.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I added Yinghai to the CC: list, but I forgot to add
linux-pci@vger.kernel.org.  Please add that on any future replies.
