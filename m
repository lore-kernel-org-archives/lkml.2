Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab2HXUZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:25:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57063 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab2HXUZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:25:48 -0400
Date: Fri, 24 Aug 2012 22:25:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
Message-ID: <20120824202544.GA23427@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Jones <davej@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
	wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
 <201208231814.21168.tweek@tweek.dk>
 <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
 <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
 <5037C530.3000408@zytor.com>
 <20120824185741.GC5094@thunk.org>
 <20120824201358.0f086c9a@pyramind.ukuu.org.uk>
 <20120824195856.GD5094@thunk.org>
 <20120824200642.GA8543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120824200642.GA8543@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 04:06:42PM -0400, Dave Jones wrote:
> On Fri, Aug 24, 2012 at 03:58:56PM -0400, Theodore Ts'o wrote:
> 
>  > BTW, it turns out I was wrong about Linux being used on Mars.
>  > Apparently Linux was used on the Mars Global Surveyor, as well as the
>  > Sprit and Opportunity rovers
> 
> citation? My recollection was that they were running VxWorks.

... on a "a radiation-hardened version of the IBM PowerPC 750." So no
x86.

http://www.pcmag.com/article2/0,2817,2408127,00.asp

-- 
Regards/Gruss,
    Boris.
