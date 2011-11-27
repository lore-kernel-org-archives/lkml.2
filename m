Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1K0GkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:40:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48916 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1K0Gj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:39:59 -0500
MIME-Version: 1.0
In-Reply-To: <4ED1D7BE.7040401@openwrt.org>
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com>
	<201111250203.29786.rjw@sisk.pl>
	<201111262232.46195.rjw@sisk.pl>
	<201111262337.43771.rjw@sisk.pl>
	<CAJ-Vmo=yh_maZtccaBkqZwip-ubjR4U471ALPwYwTurMaQrZ9Q@mail.gmail.com>
	<4ED1D7BE.7040401@openwrt.org>
Date: Sun, 27 Nov 2011 14:39:58 +0800
X-Google-Sender-Auth: U5fMvWl2VYZCdhkyTrQKZhxvxu4
Message-ID: <CAJ-VmokUf_U5e2fFt4eNOSRZ_AAXH_OC8obBJr3zDB7KmXC-tA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Revert change that broke AR928X on Acer Ferrari One
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2011 14:25, Felix Fietkau <nbd@openwrt.org> wrote:
>>
>> if (AR_SREV_9300_20_OR_LATER(ah) && !AR_SREV_9480(ah))
>>     REG_WRITE() ...
>>
> I checked again, the !AR_SREV_9480(ah) was intentionally removed in a
> later change, so using AR_SREV_9300_20_OR_LATER(ah) is correct.

Cool. I'm glad we got to the bottom of this one.


Adrian
