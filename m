Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1B1KuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:50:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46637 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1B1KuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:50:03 -0500
Date: Mon, 28 Feb 2011 19:49:57 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 01/09] ARM: s3c2442: gta02: Fix usage gpio bank j pin
 definitions
In-reply-to: <4D6B7D19.1050103@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-id: <003301cbd735$40353b20$c09fb160$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvXNJsQ+YFxl90cQ6G4YMjKfkokKwAAFGKg
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <000801cbd712$907019c0$b1504d40$%kim@samsung.com> <4D6B7D19.1050103@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> On 02/28/2011 07:41 AM, Kukjin Kim wrote:
> > Lars-Peter Clausen wrote:

(snip)

> >
> > Yeah, old S3C2440_GPJx has removed.
> > Is the S3C2410_GPJ(1) right instead of S3C2440_GPJ1?
> 
> I think so. At least the the compile errors are gone and the drivers using
> these gpios work as expected.
> 
Ok, you mean test it on board...so will apply into my s5p-fixes-for-linus
for 38-rc.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

