Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HEHnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:43:52 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:29094 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1HEHnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:43:49 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 03:43:48 EDT
X-SBRS: None
From: <Huewe.external@infineon.com>
To: <bfreed@chromium.org>, <linux-kernel@vger.kernel.org>
CC: <tpmdd-devel@lists.sourceforge.net>, <m.selhorst@sirrix.com>,
        <srajiv@linux.vnet.ibm.com>, <debora@linux.vnet.ibm.com>
Subject: RE: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a
 sequence of requests.
Thread-Topic: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a
 sequence of requests.
Thread-Index: AQHMU0G70g5YLl7U2UKF9vlb2nQYCJUN3Qqg
Date: Fri, 5 Aug 2011 07:33:58 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D44056417@MUCSE501.eu.infineon.com>
References: <1312405730-22741-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1312405730-22741-1-git-send-email-bfreed@chromium.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me :)

Signed-off-by: Peter Huewe <huewe.external@infineon.com>

> Subject: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a
> sequence of requests.
> 
> This is derived from Peter Huewe's recommended fix:
> 
> On some ChromeOS systems, a TPM sharing the I2C bus with another device
> gets confused when it sees I2C requests to that other device.
> This change locks the I2C adapter for the duration of the full sequence
> of I2C requests the TPM needs to complete.
> 
> smbus_xfer is not supported, but SMBUS is not supported by the original
> driver, either.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> ---

