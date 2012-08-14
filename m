Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2HNRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:06:27 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:49959 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab2HNRG0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:06:26 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Tue, 14 Aug 2012 19:06:05 +0200
Subject: Remoteproc: Translating between host and device addresses.
Thread-Topic: Remoteproc: Translating between host and device addresses.
Thread-Index: Ac16PoUV7RJ12EHBRZGnsC2P1ZGX0w==
Message-ID: <81C3A93C17462B4BBD7E272753C1057923B924C92D@EXDCVYMBSTM005.EQ1STM.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

I have one question related to address translation between device
address and host-physical address referencing the data-buffer
transported in the virtio-rings.
The address used in the virtio-ring is the host-physical-address,
but the mapping between device-address and host-physical-address is
not necessarily known by the device. In my case.

One way for the device to figure out the translation between
host-physical and device-address is to peek into some CarveOut
resource entry and compute this translation. Because a CarveOut
resource entry contains both the host-physical-address and the
device address for the same memory location. But this feels
like a workaround, shouldn't we make a more explicit way of
communicating this mapping between host-physical and device
addresses?

Regards,
Sjur



