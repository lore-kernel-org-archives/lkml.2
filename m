Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0HUUr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:47:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35830 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0HUUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pVX1FE4k56ML0ZUOAMfNFIYmOm4fSyYcQK38jDWrmm+E56yOJA43Aca9M3VDkF/IqN
         fRSscD//CzPTcMKT5uRyylGSB1uKNn/Mbfbz+QyWyZwmqv1Axhzd2SRqrnM86WA1JdZj
         mN4HO5zAOhm3K47Ch8DcBHtzFKAEKV7nZTvlE=
Message-ID: <4C703B78.6080005@gmail.com>
Date: Sat, 21 Aug 2010 22:47:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Someone Something <fordhaivat@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How the heck do I get started?
References: <AANLkTi=9y=_NnC349523E_qgJ2nSk1++3Z_Phx+GMJW4@mail.gmail.com>
In-Reply-To: <AANLkTi=9y=_NnC349523E_qgJ2nSk1++3Z_Phx+GMJW4@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 07:56 PM, Someone Something wrote:
> How should
> I get started hacking on it? Writing modules, or just browsing through
> the code and trying to understand it? Any books you guys recommend?

Go through
Documentation/kernel-docs.txt
and
http://kernelnewbies.org/KernelJanitors

> 1) Does the linux kernel use pages AND segments? Or just one of them?

Speaking of x86 32-bit, both. Segments are a whole space 0-4G though, so
fairly unused except some small kind of protection. x86 64-bit removed
segmenting support.

> If its pages, how does it deal with the wasted memory at the end of
> each page? Very small pages?

Which wasted memory? No memory is wasted. If code needs memory <
PAGE_SIZE, one of slab allocator is used.

> 2) I looked at the 0.01 kernel and it has this weird mix of nasm and
> gas syntax for its assembly. Why's that?

0.01 is the ancient history, who cares?

> 3) Is there some kind of tracker for the kernel where it lists bugs and stuff?

bugzilla.kernel.org
And some reports are reported solely to this (or other) ML.

> 4) If I do have a patch I'd like to submit, how would I do this?

See
Documentation/SubmittingPatches

And Documentation/00-INDEX is of interest usually.

hth,
-- 
js
