Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab1GSNWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:22:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GSNWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:22:00 -0400
Date: Tue, 19 Jul 2011 15:21:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Prarit Bhargava <prarit@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/34] System Firmware Interface
Message-ID: <20110719132157.GG8006@one.firstfloor.org>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com> <1310994528-26276-2-git-send-email-prarit@redhat.com> <m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 10:05:44AM +0100, Alan Cox wrote:
> > Could you expand somewhat WHY you want this. What is wrong with the
> > current code?
> 
> See the previous discussions

Ok I will put that now as description into all my code submissions @)

Seriously, that REALLY belongs into a patch description.

> 
> > As for user space access on x86 "dmidecode"/libdmi works for nearly everyone,
> > doesn't it?
> 
> "on x86" (and on PC only generally)
> 
> There are three core problems
> 
> 1.	DMI in this sense is basically an x86 PC class device hack
> 2.	It is obsoleted and at some point it'll vanish even on PC

Huh? What obsoleted it? 

> 3.	Every other platform without DMI would benefit from the
> 	interface being generic

Can you expand on that? The information will be always system
specific anyways. Do you really think there's that much commonality?


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
