Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1B1PVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:21:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab1B1PVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:21:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guan Xuetao <epip@hera.kernel.org>
Subject: Re: [PATCH 14/17] unicore32 machine related files: add i2c bus drivers for pkunity-v3 soc
Date: Mon, 28 Feb 2011 16:21:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1298821856.git.epip@hera.kernel.org> <af52fefef7d120cd6bcdd10c115f276c445c45bf.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <af52fefef7d120cd6bcdd10c115f276c445c45bf.1298821856.git.epip@hera.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281621.10091.arnd@arndb.de>
X-Provags-ID: V02:K0:FEa02ZBDKVIG79R0yTeVYVLtlI2zz7pdjny95f1gpSS
 mQ0yEXsclFNACspDckUbG3N508hcPlPXVVKZfeFx4yjnz646bz
 rBInWSmtSd8JI+2CvmqZktbodWlON6Yx22HsPXDTf/dMQbZeZa
 OFFmaB7QgjvOV9JQpKzeYu/wARL9yUjtD4l4jg66agGb9zwKLg
 pVrEjnfeIfngjPQOTlEdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> From: GuanXuetao <gxt@mprc.pku.edu.cn>
> 
> change from original version -- by advice of Jean Delvare
> 1. remove global variable i2c_reg, replaced by local variables
> 2. replace ENXIO with ENODEV when no platform resources
> 3. add adapter->nr assignment before i2c_add_numbered_adapter() call
> 4. add judgement for i2c_del_adapter() return value
> 5. release adapter when driver removed
> 6. add __devexit for puv3_i2c_remove() function
> 7. modify several names to more appropriated ones
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>
