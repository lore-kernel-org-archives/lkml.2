Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0KIJt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:49:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0KIJt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fCYhQz8qxHPYaArnetNOXhofiMuWe6G0dSBPTSsNbKCACvF9XhPQpFJGLs782zDifo
         Sg2McN054uq7/62b70y4+49q9sqsyC0Z7XGCBxfcxJlqTagaZOV1JO/v1tgBPZNV4RfK
         u5gCnDojycwU/rWyFZXBQ3PejpjuL35yfWnlA=
MIME-Version: 1.0
In-Reply-To: <20101109093925.GA21814@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<1289147348-31969-6-git-send-email-alchark@gmail.com>
	<20101108041721.GA11605@linux-sh.org>
	<20101108141407.GA25739@alchark-u3s.lan>
	<20101108204315.GA12050@linux-sh.org>
	<AANLkTikXffMT9ZiUpm2QAoW+KPJN3MBf55Dgruj1EJN0@mail.gmail.com>
	<20101108213008.GB17708@linux-sh.org>
	<20101108234239.GA20819@alchark-u3s.lan>
	<20101108235407.GB18385@linux-sh.org>
	<AANLkTim047K-RjLLcz3124Wm+-he8s5AirAsD6R_kitN@mail.gmail.com>
	<20101109093925.GA21814@linux-sh.org>
Date: Tue, 9 Nov 2010 12:49:25 +0300
Message-ID: <AANLkTi=es0vAWeNjWMDEi8Es97uxsgb9A2aNovp7z8Uh@mail.gmail.com>
Subject: Re: [PATCH 6/6 v4] ARM: Add support for the display controllers in
 VT8500 and WM8505
From: Alexey Charkov <alchark@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/9 Paul Mundt <lethal@linux-sh.org>:
> On Tue, Nov 09, 2010 at 03:03:01AM +0300, Alexey Charkov wrote:
>> Is there anybody I should address specifically to get this merged?
>>
> I've set up an fbdev tree now, so I'll just take this through there. It
> looks like the ordering shouldn't be important, so this can be applied
> independent of the rest, and it simply won't show up until the other bits
> have settled in .38.
>

Yes, the different parts of the patch series are completely
independent, apart from the corresponding platform definitions and
memblock reservations that take place in PATCH 1/6 (which contains
basic board code).

Thanks,
Alexey
