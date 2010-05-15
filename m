Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0EOOT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:19:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:57112 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0EOOT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ctoi0fWwDfxswEa2CFBWddrPJWvleUmjP9UU/tg2pbKCoUmI+TM2iYFrYm5256KNag
         sT9CDy2pdjBxc6R2EgMm2gfFaOz56uMZN+SuEC650rgsamAO6o7TuxQK50R5OethuaBj
         G+A/cKaI0GEkvwsWROIppV+sKJ8NlYwDU4ZcI=
MIME-Version: 1.0
In-Reply-To: <20100514230346.GA4442@xanatos>
References: <20100514230346.GA4442@xanatos>
Date: Sat, 15 May 2010 16:19:25 +0200
Message-ID: <AANLkTim7LkP1MUYzzE8BvfCHIKmDkndh-fmODC5y3h4O@mail.gmail.com>
Subject: Re: Too many printks leads to hang?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andiry Xu <andiry.xu@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Sat, May 15, 2010 at 1:03 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> Is it expected that excessive printks from interrupt context could lead
> to a system hang?  One of the stack traces I could grab looks like this:
>

I have seen spurious hangs while debugging a device driver, which
printk()d hundreds of messages per second.
Disabling netconsole solved all issues for me.

This was with Ubuntu 9.04 on x86 and I didn't update the kernel on
that machine yet, but I really should try against upstream kernel /
netconsole.

Regards,
-- 
Leon
