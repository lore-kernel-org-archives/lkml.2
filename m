Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1K2Msx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:48:53 -0500
Received: from mout0.freenet.de ([195.4.92.90]:45307 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1K2Msu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:48:50 -0500
Message-ID: <4ED4D47B.5000005@01019freenet.de>
Date: Tue, 29 Nov 2011 13:47:55 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0.1) Gecko/20111121 Firefox/8.0.1 SeaMonkey/2.5
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
References: <4ED43A5C.9000102@gmail.com> <20111129114603.GB7299@redhat.com>
In-Reply-To: <20111129114603.GB7299@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka schrieb:
> On Mon, Nov 28, 2011 at 07:50:20PM -0600, Robert Hancock wrote:
>> I recently got an Asus USB-N13 USB Wireless-N adapter which
>> apparently uses a Ralink RT3072 chip. I'm using it with an Asus
>> RT-N16 access point running TomatoUSB. When running Windows the
>> performance is reasonable (about 80 Mbps in both directions).
>> However under Fedora 16 (currently kernel 3.1.2) the performance is
>> abysmal (10 Mbps or less with lots of packet loss). I'll post some
>> debug information below.
> rt2800usb needs fixing. I'm able to reproduce these performance
> problems locally. They are quite hard to debug, and need some
> experiments. But I hope I will provide patches soon or leter.

I really appreciate your work! If you want, I can do some tests for you.
I've a rt3572 based USB WiFi dongle, which could be tested with a single
threaded machine and a multi threaded one.


Good luck!
Andreas
