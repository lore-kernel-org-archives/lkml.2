Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab2HHPGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:06:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab2HHPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:06:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 09/11] regulator/twl: remove fixed resource handling
Date: Wed, 8 Aug 2012 15:06:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-10-git-send-email-arnd@arndb.de> <20120808145018.GD24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120808145018.GD24328@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081506.24773.arnd@arndb.de>
X-Provags-ID: V02:K0:TnNbTJrsND31xOuSA+OrA2Z0cAAaZYbVVccIOYe9Pxg
 /QsmqHSzyNPh9DyAbsgpwC6vVO/jD89ocyx5X0X2gBwziJk3jq
 yvpx/o8o2BzXtBHJYOWnyTWoYQL7T83FBOUMCzUg+jAzNLuz51
 tYarRCjsdY4mD2yvY23qXH5xk+7IQMcblrACw8oOE4xwkvZhAn
 4lCwhUKjCEeP0yjHLAnJF1UnXa/oVXZGfxNN8QFtzu/p20I2AU
 s6ctDddBEbU4IL+9PK0FU8MoFCg9UNlftmwshfOgniybKJPpm/
 33Y6rv8ht4xlYyJ2RWpxQOFjiZNAZNv8VM/hvfkID0VmpglmiF
 senqwUZFv1Btedb68qHw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Mark Brown wrote:
> On Wed, Aug 08, 2012 at 04:47:26PM +0200, Arnd Bergmann wrote:
> > The recent patch 0e8e5c34cf "regulator: twl: Remove references to
> > 32kHz clock from DT bindings" removed the only use of the fake
> > "CLK32KG" regulator but not the TWL6030_FIXED_RESOURCE and
> > twl6030_fixed_resource definitions that are unused otherwise.
> 
> I've already got a fix for this in my tree.

Ok, dropping it here.

	Arnd
