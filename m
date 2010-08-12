Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719Ab0HLVYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:24:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57536 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0HLVYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Oh/h5XPxYRFOut487+5uy6RDdC3lfCV9ReHxH1Pw86DKdmja6dZ6z21FAG8wNydNqK
         itLsHWUnVTQfdAoNox6kQP++g36cqd/Whm1T6LdmtrQkRbnc2VzIZjPUpLuimXNcV2U5
         2s7YtkHmfKU7ZP3tKriOmyC7Z7k45mOGJnn8k=
Message-ID: <4C64669B.1020605@gmail.com>
Date: Thu, 12 Aug 2010 23:24:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36: Sound stop working
References: <201008122200.05598.thomas@m3y3r.de> <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com> <s5hpqxntw64.wl%tiwai@suse.de> <4C646110.1040104@gmail.com> <AANLkTi=-2U3PXeUEXzGDdXti_j5yGbfG3yci909MKEHX@mail.gmail.com>
In-Reply-To: <AANLkTi=-2U3PXeUEXzGDdXti_j5yGbfG3yci909MKEHX@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 11:18 PM, Linus Torvalds wrote:
> On Thu, Aug 12, 2010 at 2:01 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> Probably I got into this problem yesterday. Found out that PA fails to
>> open /dev/snd/pcmC0D0p _second_ time. It opens it, then closes, then
>> opens it again and gets EBUSY. aplay is OK.

Perfectly reproducible in qemu-kvm with ac97 soundhw, i.e. intel8x0
driver. Just in case you want to debug that easily.

-- 
js
