Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1GUR0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:26:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53438 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1GUR0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:26:16 -0400
MIME-Version: 1.0
X-Originating-IP: [92.140.109.150]
In-Reply-To: <4E28313E.60900@drcomp.erfurt.thur.de>
References: <20110719143758.GA15283@linuxaudio.org> <CAFEhRJf-5U=cS3iptpvGEVSHV+S=aBF_mWfWkC_QMRty_WnoPA@mail.gmail.com>
 <20110720131120.GA1836@linuxaudio.org> <CAFEhRJd9ZCSpx52S__vMdWK18mhMQrRoU9R5zNaZE=wksLRTvg@mail.gmail.com>
 <20110720153023.GA11502@linuxaudio.org> <CAFEhRJczj=_B7fK7GvBEnqpB2GJGnCnGkoA2w5vzbFfM2wAGZw@mail.gmail.com>
 <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com>
 <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com>
 <20110721112331.GA15059@linuxaudio.org> <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com>
 <4E28313E.60900@drcomp.erfurt.thur.de>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 21 Jul 2011 19:25:56 +0200
Message-ID: <CAG-2HqVew75LE68fObz7e3WwcT-5Gwu1ka9Zr4vb1JdbSUOYEQ@mail.gmail.com>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
To: Fons Adriaensen <fons@linuxaudio.org>
Cc: General Discussion about Arch Linux <arch-general@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Adrian Knoth <adi@drcomp.erfurt.thur.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 4:01 PM, Adrian Knoth <adi@drcomp.erfurt.thur.de> wrote:
> On 07/21/11 15:00, Tom Gundersen wrote:
>
> Hi!
>
>>>>>>> * The driver for my card (RME HDSP MADI, snd_hdpsm) is loaded.
>>>>> [   48.057757] HDSPM: unknown firmware revision cc
>
>> firmware revision is 0xCC, which is not recognised. If your card is
>> MADI, the kernel expects the firmware revision to be 0xD2 (or starting
>> in 3.0, it also accepts 0xCF).
>
> Exactly.
>
>> I guess this can be fixed easily by adding your firmware revision to
>> the list of accepted revs.
>
> I hope so, too. Please try the attached patch.

Fons (or anyone else who could reproduce the problem),

If you want to try out Adrian's patch, I uploaded a kernel with the
patch applied here:
<https://dev.archlinux.org/~tomegun/kernel26-2.6.39.1.3-1.1-i686.pkg.tar.xz>.

Cheers,

-t
