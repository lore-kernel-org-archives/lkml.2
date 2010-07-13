Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0GMUql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:46:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64841 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0GMUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pri79IgfeBMypzqqkv2mCDod4TElGgEUrpwAy0lnDEWsBcND4BBeyqenBPz/2zPXqq
         PpCpwOba/lKhUXix/Kuy6tmPwrGJ8D3zE3VcbzKYdg8N7n/4I+d6VsD9p5ZYNFvKOIS7
         FOuA969wgoAUiqTlBg+iMMuyC7Ts08PF0VPh4=
MIME-Version: 1.0
In-Reply-To: <4C3CCE05.4090505@kernel.org>
References: <4C3A3B27.7020009@oracle.com>
	<4C3AD94C.7070807@cs.helsinki.fi>
	<4C3B38F7.1050400@zytor.com>
	<4C3B40F3.6070009@kernel.org>
	<4C3CA5A9.6000607@cs.helsinki.fi>
	<4C3CCE05.4090505@kernel.org>
Date: Tue, 13 Jul 2010 23:46:38 +0300
X-Google-Sender-Auth: FJ-VcPnpLo-YqZAlLrHSg9SopMU
Message-ID: <AANLkTimYQPaF6YH2aMBf3nprmxLFVDDYLG4gxxD3VyBa@mail.gmail.com>
Subject: Re: [PATCH] x86: Setup early console as early as possible
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:35 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> [PATCH] x86: make boot code to analyze console=uart8250 too
>
> So we use console=uart8250,io,0x2f8,115200n all the way
>
> Also add back simple_guess_base(), otherwise those simple_strtoull(,,0) are not
> going to work.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Cool! Thanks Yinghai!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
