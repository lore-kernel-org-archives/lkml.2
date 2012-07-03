Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2GCI7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:59:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2GCI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:59:28 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm tree related)
Date: Tue, 3 Jul 2012 08:59:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au> <201207030806.49561.arnd.bergmann@linaro.org> <20120703081138.GA25183@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120703081138.GA25183@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207030859.11975.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:WiKYydZXT9mCZuhqXbmyfA1FTK9+fBZ1KuKtCQUuoTe
 291yuM3aX/I2tvry+bFK2nLmOUelwQLiKJJpy3fSrJYLUIvo8d
 lyjtY+rSCAZyuwBIlfCj20/2+ord6yWSmvyDMuc+Aotvi9z4b1
 LSEH5oSuTB7i830HFDtXIFGusvwGfEGBQOC5QtDPS6tA2+tMmo
 nh+hoFl4M+LOZhyxrr6TDfBm2G1uJIyDBv+HSJIWXXo3BqzvWg
 gjlJS6bLqcYvncCH+eZzmy8/0c5UCiUCrtyddWr6+gRhMmxoup
 hhSM1wvqrvoheuLlxIaqsFHAP3LeqddkLX/fqis94SZ4Onbpkh
 q0TKaTp914kLvqw2bFjKjDZFF5WXDW1AULCEOUqZz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012, Thierry Reding wrote:
> I came up with the attached patch. What do you think? It fixes the
> PowerPC allyesconfig issue for me.

This one looks correct, but I would still do it the other way around,
putting the depends statements into the locations of the other drivers.
The main difference is that we can then independently convert the
remaining drivers, without having merge conflicts in the same line
every time we remove one of the dependencies.

	Arnd
