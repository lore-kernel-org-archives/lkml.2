Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2HPGkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:40:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2HPGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:39:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (regulator tree related)
Date: Thu, 16 Aug 2012 06:39:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120816151605.b0a9932005b541956288ce96@canb.auug.org.au>
In-Reply-To: <20120816151605.b0a9932005b541956288ce96@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208160639.47131.arnd@arndb.de>
X-Provags-ID: V02:K0:h7kyekrrIYaT1jQDKUQAvJp//EBusvIRMmmcmKXnf7y
 w0lish2v6Y2eCL8F39c/cXAV4iSGEhQjwVs/z1qe+P5+x6pPx9
 HNOHkvT75JNo3CmrycLNsQmvD87zxoy46n4a+fcJdzGvaIaFg7
 CXB4CZSRSAYC5XeVmOruTNHvGjI0qsu8/dXrSMDTdfHFE6wihx
 txS3Vv5J/t3CtlSMVOaJ+VA6drAFHGmfNxp2VtjTyj6f8ldCuM
 43G7VbnFF3Vw9WTBNQ7lTigyZ0ZcixL7YvEZnPQ+vWIha0Fl1N
 HZDtMK9REeyRN7Cka8aWcjFg34s6xexakkbTnaG6s6OicZwgvS
 WGMjq6+itDXDDklE63xk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Stephen Rothwell wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 16 Aug 2012 15:11:22 +1000
> Subject: [PATCH] regulator: using kfree() requires including slab.h
> 
> Fixes this build error:
> 
> drivers/regulator/twl-regulator.c: In function 'twlreg_probe':
> drivers/regulator/twl-regulator.c:1229:3: error: implicit declaration of
> function 'kfree' [-Werror=implicit-function-declaration]
> 
> Also added string.h for kmemdup().
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks Stephen and sorry for bothering everyone with this. I had
actually found the same problem and fixed it locally but forgot
to send out the fixed version.

	Arnd
