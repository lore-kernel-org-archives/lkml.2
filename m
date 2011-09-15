Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1IOKnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:43:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOKnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:43:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Date: Thu, 15 Sep 2011 12:43:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com>
In-Reply-To: <1316017900-19918-6-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109151243.13664.arnd@arndb.de>
X-Provags-ID: V02:K0:iNRoMz/uDzEH//mpJS120ycof5cHxTqxq8sMofExGsX
 I3X/+kLsxsRAu6G6PvwQEhgaFk75gAy/mfZYzz5DHelBUqUvy2
 w5j4sP/CtGmmkArvFnEeErfMQs8Kvrvz8iEgw6ZJ1Wf0skIc+3
 AKW2hFFEJBJJkMA2DyMpwJDvdA+txXOOBPrBSqbQMZp3cfoWaO
 SemikorhBjxIhg6DOcBW2pm+UPz/GCuH4mtk28C7bVnYJrpuOZ
 7/VQd2d2oXsK218tYHPuwnhud4H8NntPENAdMgVfXuH8NqUDzq
 Xj0SHs+P/c8jIPQGsG1RY0B/Z9J/UplN3Nn+DikjViTypPQXYV
 i0K83PtOXnlilUP4ecX4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 September 2011, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This adds gic initialization using device tree data. The initialization
> functions are intended to be called by a generic OF interrupt
> controller parsing function once the right pieces are in place.
> 
> PPIs are handled using 3rd cell of interrupts properties to specify the cpu
> mask the PPI is assigned to.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
