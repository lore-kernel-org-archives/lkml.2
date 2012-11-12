Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2KLSgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:36:35 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:53467 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2KLSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:36:34 -0500
Date: Mon, 12 Nov 2012 19:36:31 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 2/4] avr32, kconfig: remove HAVE_ARCH_BOOTMEM
Message-ID: <20121112183631.GA18118@samfundet.no>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
 <1352737915-30906-2-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352737915-30906-2-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 13 Nov 2012 01:31:53 +0900 or thereabout, Joonsoo Kim wrote:
> Now, there is no code for CONFIG_HAVE_ARCH_BOOTMEM.
> So remove it.

Indeed, thanks for cleaning. In a not too distant future I'll re-establish
the AVR32 tree on kernel.org, I'm just waiting for my account to be
made/enabled again.

> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
