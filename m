Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab2CWUh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:37:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33638 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab2CWUh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <1332529371-3994-1-git-send-email-alexg@meprolight.com>
References: <1332529371-3994-1-git-send-email-alexg@meprolight.com>
Date: Fri, 23 Mar 2012 17:37:26 -0300
Message-ID: <CAOMZO5Cf11Z3JNnsDU2c1YX5Fh=4qznc+26xndKHB1wQMDMu_g@mail.gmail.com>
Subject: Re: [PATCH v1] i.MX35-PDK: Add Camera support
From: Fabio Estevam <festevam@gmail.com>
To: Alex Gershgorin <alexgershgorin@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, s.hauer@pengutronix.de,
        g.liakhovetski@gmx.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Alex Gershgorin <alexg@meprolight.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Fri, Mar 23, 2012 at 4:02 PM, Alex Gershgorin
<alexgershgorin@gmail.com> wrote:
> Yes, yesterday I sended to Sascha and ARM mailing list another patch
> i.MX35-PDK-Add-regulator-support, this also will need be used.

Ok, good. I saw that patch as well.

It would be really nice if you could fix the I2C issues you reported
earlier in software.

Otherwise the camera will only work on your own modified mx35pdk ;-)

Regards,

Fabio Estevam
