Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1GTM70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:59:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50580 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1GTM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110719175432.GA23018@srcf.ucam.org>
References: <4E257E33020000780004E319@nat28.tlf.novell.com>
	<CADZ9YHiBkfcM3jjjJVh_Ydn+uJxjYM6SnDZ=5J3Mmki7fp3NbQ@mail.gmail.com>
	<20110719175432.GA23018@srcf.ucam.org>
Date: Wed, 20 Jul 2011 18:46:07 +0600
Message-ID: <CADZ9YHi34K=MKCKLfjwz07eWK+nDRiggrE4PZE6BPNrHQeABOQ@mail.gmail.com>
Subject: Re: [PATCH] x86: serialize EFI time accesses on rtc_lock
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 11:54 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jul 19, 2011 at 11:32:05PM +0600, Rakib Mullick wrote:

> That's just assigning some function pointers, not actually making the
> calls. There's potentially several routes to each of the calls, so it
> makes sense to do the locking there.
>
I got confused by the patch subject. I thought, this serialization is
required at the time of startup.


Thanks,
Rakib

> --
> Matthew Garrett | mjg59@srcf.ucam.org
>
