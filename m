Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1B1PRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:17:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1B1PRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:17:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Guan Xuetao <epip@hera.kernel.org>
Subject: Re: [PATCH 13/17] unicore32 io: redefine __REG(x) and re-use readl/writel funcs
Date: Mon, 28 Feb 2011 16:17:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1298821856.git.epip@hera.kernel.org> <b05e05c32279bbb45939006a6bbaf7e7183f14ce.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <b05e05c32279bbb45939006a6bbaf7e7183f14ce.1298821856.git.epip@hera.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281617.00462.arnd@arndb.de>
X-Provags-ID: V02:K0:UvUSgSMuBGXKNnPe3lnffoBTuRBv7Fy5JHLIYchcZKe
 5x0Ti2GN8jtIEkz4Ki755PQZpWCO76GivwR2+CCq9czOwif/WN
 jRjXO6Cos99eJpLrZEh71VUYGlGed7bVOsZYt+umxgsb18swzH
 d+w10C8BpUvwTCQnP97c3AWFX4YKIM92ZT8N/mceKDPSxKYkTB
 ont4Q6Ez3ez2esZI9/HeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> From: GuanXuetao <gxt@mprc.pku.edu.cn>
> 
>   -- by advice of Arnd Bergmann
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I was expecting this to get folded into the patches that introduce the files,
but this way is fine as well.
