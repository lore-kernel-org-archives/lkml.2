Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1CNTqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:46:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1CNTqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:46:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Mon, 14 Mar 2011 20:46:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <> <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <4D7E6A38.7010801@cam.ac.uk>
In-Reply-To: <4D7E6A38.7010801@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103142046.25393.arnd@arndb.de>
X-Provags-ID: V02:K0:pIaw/ZVOPLl5Em5hqCnt2cqHdmxnCnyZUxKNBoSaKLL
 ZVlvxLBH5hlKwv9U2nle1/85VorGk1OBUSiDQwAQGf7AxjAcvy
 bVmrI2cZtF8UzzuvWlG9qrOsCih70sDCf//EInipwL1UBzRnVr
 HR8K38lK5/d7H/ujg5+zN19KYTeDq9tmide6KmhoUwYmTkmz/i
 PGmdT+wM94I+pi5HVmqDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011 20:19:20 Jonathan Cameron wrote:
> The big issue raised last time around is that this is not a conventional human
> input device.  Hence Dmitry isn't going to take it into input.  That doesn't
> just mean that you have to move it's physical location; it also means you have
> to not use the input interfaces at all.

How about making this a hwmon driver instead?
There are already a number of temperature sensor drivers in
driver/hwmon/, I think it would fit in well there.

This would mean moving it to the other directory,
registering it to the common hwmon api (hwmon_device_register)
and rewriting the user API to blend in with the other
hwmon drivers.

	Arnd
