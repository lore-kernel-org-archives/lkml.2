Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1BMQtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:49:03 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49736 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1BMQs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vReqYEXRkO3hfEne8kStjgJ45NoO38nKIPbzJV4026AMpGqLbIWL/e7auf1oLtaiyK
         onnycRwlDfjLu3vL6IMhOQ/LGfddbKNArkbq+02rIABnza56n8XxoQ+gboq6KFpXyNNH
         X2mp00D1pY2tSC4MDPHUTiFWrvYWctdqP/b+o=
MIME-Version: 1.0
In-Reply-To: <20110213163556.GH13985@machine.or.cz>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
	<4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
	<AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
	<87tyg8j7le.fsf@mid.deneb.enyo.de>
	<AANLkTin1cTCVNTiLS792ZkG9_Y5OvXCtDXHRFfY7hbSF@mail.gmail.com>
	<20110213163556.GH13985@machine.or.cz>
Date: Sun, 13 Feb 2011 08:48:57 -0800
Message-ID: <AANLkTikQF-WgRrw1o0aX2a1HxYMDLbELnTaL5=iVQR-E@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Petr Baudis <pasky@suse.cz>
Cc: Florian Weimer <fw@deneb.enyo.de>, x32-abi@googlegroups.com,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/13 Petr Baudis <pasky@suse.cz>:
> On Sun, Feb 13, 2011 at 07:13:57AM -0800, H.J. Lu wrote:
>> On Sun, Feb 13, 2011 at 7:07 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>> > * H. J. Lu:
>> >
>> >>> Actually, I'm wondering if you can do the translation in user space.
>> >>> There already are 32-on-64 implementations in existence, without
>> >>> kernel changes (recent Hotspot, LuaJIT, and probably some more).
>> >>
>> >> Please check out the x32 kernel source and provide feedback.
>> >
>> > I still don't understand why you need a separate syscall table.  You
>> > should really be able to run on an unmodified amd64 kernel, in 64 bit
>>
>> That is done on purpose. x32 is designed for environments where the
>> current ia32 API is sufficient. You can think it as ia32 with register
>> extended to 64bit plus 8 more registers. Everything else is still 32bit.
>
> I think it would be great if you could add some text like this plus some
> rationale (AIUI, this is geared mainly at new Atoms and other x86_64
> embedded platforms) to the document.

I updated:

https://sites.google.com/site/x32abi/

> (BTW, it is not really convincing to me that such a niche is worth all
> the trouble this is going to bring.)
>

That is a good question.  Otherwise x32 would have been implemented
long time ago.


-- 
H.J.
