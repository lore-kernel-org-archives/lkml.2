Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab1C3JcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1C3JcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32 ldscript fix: add cacheline parameter to PERCPU() macro
Date: Wed, 30 Mar 2011 11:31:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <01ed01cbeeb7$de2e1920$9a8a4b60$@mprc.pku.edu.cn>
In-Reply-To: <01ed01cbeeb7$de2e1920$9a8a4b60$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301131.59054.arnd@arndb.de>
X-Provags-ID: V02:K0:weo6pFL+oPQ35YFoCtmY3abyR9VR0QaCkCoSkvGQK+k
 AKT0ZL1QHnFmwXhH83ePJvHdJHQAhDupFgKubu/SPKUezgkVK6
 vbc7ttEBI2hGLVQ2O7XhjE8mOgIowdB0dnY+TtahB7l1LMIj7O
 6liq1K1frM0oRYCe9/kfPJRIijFozHmu+sdliV8cNY9f0nWHtL
 0D8d70N8eQ2sS4QGqtw0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Guan Xuetao wrote:
> 
> Also, adjust cacheline parameter of RW_DATA_SECTION and EXCEPTION_TABLE
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>
