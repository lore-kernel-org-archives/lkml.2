Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0LOJ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:29:10 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46484 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LOJ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:29:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VTc1KCQ6R+q9Bu9vUlgIUBKYT5yOGcbPk5yAB7IROsucGEV7MrvFlbDYuDTMk9SGrn
         GotlCiYJGiu5rN0WTATKEtyHZygFQD8v6rIzW87jjK3QWZC+enIsc+ROefOQs4ru6hMp
         SJJfyCjsuyNNfagOKe7wqAVIZAfx2JgTejMYY=
MIME-Version: 1.0
In-Reply-To: <b9dded$hcr3k7@orsmga002.jf.intel.com>
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com> <b9dded$hcr3k7@orsmga002.jf.intel.com>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 15 Dec 2010 17:28:45 +0800
Message-ID: <AANLkTim=k601vg+sJJH3bvdfAmrCbCEouL78XoVxuDwy@mail.gmail.com>
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com, ak@linux.intel.com,
        gregkh@suse.de, stable@kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 17:23, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> Which chipset and what connectors? Judging by the offending commits, my
> guess is an Arrandale with eDP, in which case
> https://bugs.freedesktop.org/show_bug.cgi?id=31988 will be of interest.
> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
>

lspci | grep Display
00:02.1 Display controller: Intel Corporation 82Q35 Express Integrated
Graphics Controller (rev 02)

Thanks,
Hui
