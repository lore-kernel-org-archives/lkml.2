Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645Ab1JYO1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:27:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51141 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab1JYO12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <4EA6C488.1030606@snapgear.com>
References: <201110250229.p9P2Tvth015729@goober.corp.nai.org>
 <CA+55aFzLBaLpBWA8tspNbCyzMYeruK-waRCpRwVnZEOGw9FhRQ@mail.gmail.com> <4EA6C488.1030606@snapgear.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 16:27:07 +0200
X-Google-Sender-Auth: NjmKtqmrS6hD_8advjGnFTJSLpk
Message-ID: <CA+55aFxondM5y9c2vLTnO87bTQeS4RB2LcH06YSozNZr+joZxQ@mail.gmail.com>
Subject: Re: [git pull] m68knommu arch updates for 3.2
To: Greg Ungerer <gerg@snapgear.com>
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        uclinux-dev@uclinux.org, geert@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 4:15 PM, Greg Ungerer <gerg@snapgear.com> wrote:
>
> I don't think I will get back onto kernel.org anytime soon, I am in
> the "geographically-isolated developers" group :-(
>
> But I have put a signed tag on the top commit now, with the top
> commit and repository info. Is this what you are looking for?

That works for me, except that the gpg key is just not signed by
anybody, so it doesn't really add any real trust. The fact that you
reply sanely to and react to your email address is what makes me trust
you are you, and it's not like I really worry about the m68k
architecture as a security issue ;)

So let's hope you can get your gpg key signed, but apart from that
detail you did things right and everything looks fine. So pulled,

               Linus
