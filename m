Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1BMQq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:46:26 -0500
Received: from w241.dkm.cz ([62.24.88.241]:41265 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab1BMQqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:46:21 -0500
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Feb 2011 11:46:21 EST
Date: Sun, 13 Feb 2011 17:35:56 +0100
From: Petr Baudis <pasky@suse.cz>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, x32-abi@googlegroups.com,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
Message-ID: <20110213163556.GH13985@machine.or.cz>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
 <87aai1gdr7.fsf@mid.deneb.enyo.de>
 <4D5711E0.7020306@zytor.com>
 <87r5bcnwvw.fsf@mid.deneb.enyo.de>
 <AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
 <87tyg8j7le.fsf@mid.deneb.enyo.de>
 <AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 07:13:57AM -0800, H.J. Lu wrote:
> On Sun, Feb 13, 2011 at 7:07 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> > * H. J. Lu:
> >
> >>> Actually, I'm wondering if you can do the translation in user space.
> >>> There already are 32-on-64 implementations in existence, without
> >>> kernel changes (recent Hotspot, LuaJIT, and probably some more).
> >>
> >> Please check out the x32 kernel source and provide feedback.
> >
> > I still don't understand why you need a separate syscall table.  You
> > should really be able to run on an unmodified amd64 kernel, in 64 bit
> 
> That is done on purpose. x32 is designed for environments where the
> current ia32 API is sufficient. You can think it as ia32 with register
> extended to 64bit plus 8 more registers. Everything else is still 32bit.

I think it would be great if you could add some text like this plus some
rationale (AIUI, this is geared mainly at new Atoms and other x86_64
embedded platforms) to the document.

(BTW, it is not really convincing to me that such a niche is worth all
the trouble this is going to bring.)

-- 
				Petr "Pasky" Baudis
Computer science education cannot make an expert programmer any more
than studying brushes and pigment can make an expert painter. --esr
