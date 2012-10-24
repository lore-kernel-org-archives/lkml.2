Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2JXMEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:04:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab2JXMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:04:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v3 2/5] zynq: use pl310 device tree bindings
Date: Wed, 24 Oct 2012 12:04:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>,
        Nick Bowler <nbowler@elliptictech.com>
References: <20121024003416.GC31625@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024003416.GC31625@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241204.20072.arnd@arndb.de>
X-Provags-ID: V02:K0:blG6hJTrZZJu2cPG+ZjXSyx4MGsZ+fkG8bNhtDIV+vD
 EoIO+QIlfej6GT4a3zXEKERByaaclxGOPNVAnTi62CMTifHFhW
 R8Fof20ToOqT9xp5hBk/v74ZqEWxFjXEp96NuYrpgHXTsZnHJn
 pFuJu97s+sylUD88JCwqn89ki9kHqgGJUXnOPP071gZleCgeXw
 0BLYu9X5kZR9Z+fLPysIP4M98q3s6wQdeU4P7pctAUIN6Ge3y8
 /T8Vsrhayd30qhv0uMmJ/qc9JeFiJ8V8kr1psUskBuFzk3dXLa
 a8xmBqWE5Wp5f21VWbRLo6a3MMrsZxAKPIu9t1UTPAwCpQNoJN
 v94lTDnUzNJ5L0npvg28=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Josh Cartwright wrote:
> The Zynq has a PL310 L2 cache controller.  Convert in-tree uses to using
> the device tree.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
