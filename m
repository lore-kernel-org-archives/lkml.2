Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1GAQcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:32:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab1GAQcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:32:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] tty/serial: change of_serial to use new of_property_read_u32() api
Date: Fri, 1 Jul 2011 18:32:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
References: <20110630185921.13784.3823.stgit@ponder>
In-Reply-To: <20110630185921.13784.3823.stgit@ponder>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011832.40318.arnd@arndb.de>
X-Provags-ID: V02:K0:YrPRVueKacVAlC1PEhPr/LTaUPmYaZRb4zDVMxYwBcQ
 ZxfJWLFMF59AA7CAYbGHTzmkeqiCbt6yQVLsxoUCFSuuqruFyu
 TOFC4syiefVxoRROWEyQZUusMPqdpB2YRe97J9Gy72ssBciJdw
 mSgQpNzD61c6oHCkoaR7BUKpDrXlrEFBnCrpEXDpxT2ZRNOZ/1
 Q8u9ssiE7sZdSh8SFU4kg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011, Grant Likely wrote:
> Simplifies the code a bit and drops a few lines.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Looks good to me, and Rob's comment makes sense as well.

Acked-by: Arnd Bergmann <arnd@arndb.de>
