Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1HaN0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:26:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1HaN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:26:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 04/35] Hexagon: Add atomic ops support
Date: Wed, 31 Aug 2011 15:26:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190800.097783373@codeaurora.org>
In-Reply-To: <20110830190800.097783373@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311526.32953.arnd@arndb.de>
X-Provags-ID: V02:K0:cqoX8NnIygLJbE5ezduSXhUvNK2ZP4pJPAAO6FQEVwF
 NdJKmGP1Z4kYPcaL3rK9WpFlKMN+ah3qhl7QyzKqsPYsXKu+H9
 yVVituu6y48zy8JSkPnxVV1HSBRxdmLEWuYooWhNGsIVZONsp6
 lbj2hgRz6wwqQgBXo025/gXHmtYchTBRFiQiA27Ns6CrOk7mZA
 DDBC8XNBcROUQObvS5sO3ZzACXQZk4jHzlX8ftM5GNmAMj2Ret
 KA3jvnr51IX4ZgUkQYhBdloWSPzMr2ioQ011nfHzYhN8xjkntL
 mGuHDnjZB1DE1kWsW2G48OTTIl4LYjeOQM/vq0LCuuPCoRRUmu
 Ujk+YG052hY9ZqaOUnwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> Our architecture uses load locked/store conditional type semantics for atomic
> ops.
> 
> Added inline assembly version of atomic_add_unless.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
