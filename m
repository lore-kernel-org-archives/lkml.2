Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab2KWL4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:56:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2KWL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:56:37 -0500
Date: Fri, 23 Nov 2012 12:56:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Samuel Ortiz <sameo@linux.intel.com>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: add a regulator driver for the AS3711
 PMIC
In-Reply-To: <20121123114915.GG4529@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1211231255350.14984@axis700.grange>
References: <Pine.LNX.4.64.1211221107520.28453@axis700.grange>
 <Pine.LNX.4.64.1211221110330.28453@axis700.grange> <20121123111515.GD12685@sortiz-mobl>
 <20121123114915.GG4529@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Aec03q46u44JTfvEl/61eO10D6xnAh/JsJGe3UNGAE8
 OzpO9jWW0zxkuVIwaqTV0sKUPeFZVket+3Q/ulb92zRkK6yQEs
 32PBnDvIiwPb0V5dKhQYceGyrYFV4DjptGYnl/W3eN9P2JQ3fm
 xGiLWgO7itD7PlH5eRMZgmkgnEMqWKeXtEyh+IgV3/7rmJ44LM
 OAOyu+AS3g/4F+L3nLMko9n4c6q238FGwRJxcxk1uwT/Xm70XA
 R5udzuAxTClhyvpDlyxmLIu8451w2VeAwNJjaYLa4kOYij0Hd2
 BGFRH72hayNWYZj1YGG/93K0RmvnuQiQNHn/45yWSnlPLCljFZ
 0XNjX+4ONO838j+8zje4gJ26WQEUXjbXiYSgxrBMFqryAep+g6
 TBUdO9RICBqlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Mark Brown wrote:

> On Fri, Nov 23, 2012 at 12:15:15PM +0100, Samuel Ortiz wrote:
> 
> > Mark, does that look ok with you ? There's a build dependency with patch #1,
> > so it would make sense for me to take it.
> 
> If there's a build dependency there's a problem - the Kconfig should
> prevent the driver being selected without the MFD.

Indeed there is one:

+config REGULATOR_AS3711
+	tristate "AS3711 PMIC"
+	depends on MFD_AS3711

So, should be ok

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
