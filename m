Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2IROnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:43:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2IROnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:43:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2] spi/pl022: Devicetree support w/o platform data
Date: Tue, 18 Sep 2012 14:43:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
References: <1347976433-1176-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1347976433-1176-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181443.29025.arnd@arndb.de>
X-Provags-ID: V02:K0:bqYD6sMsWBfmS4EJgy4BK4MahQf24yBE521Z9SvBDGS
 U3qmRAbo53K0pGBH9NCuiDSH3n2i6hmjXhgoAoZX9qKjhMXonr
 JjznygU0KGo7NrIerGvfbcNjV52T5NQaQYMU+Dk9hEfY/mgdll
 P900n17kbY5WQ4/fmHXsI223YlAyNLX9Sx8CYxZz4c8Pzd+C0C
 PVzSfpkrImTWVumZAXoo7fS3Igi7qb8ndEXpb7SyfP/i7+26WS
 m8owDaxW+CDS6b54wWc8opkH8Cip/qgUafMufQtu7ssDXhVuYU
 JcWZB/aiSsAgy8gwWfTTxmu8G9c95R7OUpgVLzHZgT09KRYuvl
 nman70xvGUPHCmDB1u38=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Roland Stigge wrote:
> Even with devicetree support, we needed platform data to provide some data,
> leading to mixed device tree and platform data. This patch makes it possible to
> provide all that information via device tree. Now, the data must be provided
> via platform data or device tree completely.
> 
> Only in case of DMA where a callback specification is necessary (dma_filter()),
> platform data is the only option.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
