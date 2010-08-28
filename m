Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0H1GAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 02:00:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49199 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0H1GAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 02:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=RLYkEBS4Kuli//o7dUOqqqoG5Vt2I3n9OUqeNxUSH7Wbs4Cv/QE/rB+jWzy46U8kaZ
         gvFagltxXO4xcmEd5tW76MzfFNWZwt/uKot1wZ0o4z2rKMvPqieNOm5m2SwUxjukGEDJ
         ue7KXM47TXajM03uxWKYjghr/5veMoZZiCT1c=
MIME-Version: 1.0
In-Reply-To: <20100804204002.GA22147@merkur.ravnborg.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
 <20100804115658.GA21357@merkur.ravnborg.org> <AANLkTikz7pvirg7VUxrm-6v=yrLwHy4UeaJTS0wz3BLc@mail.gmail.com>
 <20100804202806.GA22134@merkur.ravnborg.org> <20100804204002.GA22147@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 28 Aug 2010 02:00:11 -0400
Message-ID: <AANLkTik4MEU92rzbKdjb9k=L+5zoQZpHXszx_zOLmRu0@mail.gmail.com>
Subject: Re: missing .data.shared_align placement in vmlinux
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 16:40, Sam Ravnborg wrote:
> [Resend - this time with Jeremy included in To: ]
>
> Jeremy - you introduced this in ("x86/i386: Put aligned
> stack-canary in percpu shared_aligned section")
> 53f824520b6d84ca5b4a8fd71addc91dbf64357e

can we get this merged for 2.6.36 ?
-mike
