Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1BQRWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:22:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51168 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1BQRWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:22:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 03/11] unicore32 core architecture: processor and system headers
Date: Thu, 17 Feb 2011 18:22:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02e701cbcb47$c31b1680$49514380$@mprc.pku.edu.cn>
In-Reply-To: <02e701cbcb47$c31b1680$49514380$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171822.00400.arnd@arndb.de>
X-Provags-ID: V02:K0:TyearLeWfMbQpogcX7HSivAZJLpPsk5haFhpL/Nzy8C
 ECzCgo47XBDsE2ybtBJVvVjFFNaK/N8WQV9pUeP/LSUrXEySx7
 a9sLim1cUX0dz8TLRHHapr1tzYk99X2gQozvxxLIlBnejxVvmv
 xCZBrOwqIRzQGAnTXydjsz+wHYlpZDhk5ko/fDW/HFYVYCuYG8
 bPNID1w3Pf1aUIM+1zzpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, Guan Xuetao wrote:
> This patch includes processor and system headers. System call interface is here.
> We used the syscall interface the same as asm-generic version.
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
