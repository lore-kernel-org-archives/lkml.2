Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2JRVc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:32:59 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:21468 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab2JRVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:32:58 -0400
Date: Thu, 18 Oct 2012 23:32:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Shuah Khan <shuah.khan@hp.com>
cc: mtk.manpages@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>,
        konrad.wilk@oracle.com, rob@landley.net, joerg.roedel@amd.com,
        Andrew Morton <akpm@linux-foundation.org>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v2] Documentation DMA-API-HOWTO.txt Add dma mapping error
 check usage examples
In-Reply-To: <1350590458.2680.44.camel@lorien2>
Message-ID: <alpine.LNX.2.00.1210182331390.17217@swampdragon.chaosbits.net>
References: <1350230064.4069.1.camel@lorien2> <20121018094715.GC5685@mwanda>  <CAKgNAkhx2trGUMCbpYbKbMYYjq9oTeAnqG436_MP2t6noA3K-g@mail.gmail.com> <1350590458.2680.44.camel@lorien2>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Shuah Khan wrote:

> Enhance the document to discuss the importance of dma mapping error checks
> after dma_map_single() and dma_map_page() calls. Also added usage examples
> that include unmap examples in error paths when dma mapping error is returned.
> Includes correct and incorrect usages to high light some common mistakes in
> error paths especially when dma mapping fails when more than one dma mapping
> call is made.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
[...]

Nit picking :

> +Example 2: (if buffers are allocated a loop, unmap all mapped buffers when
> +	    mapping error is detected in the middle)
> +

"... if buffers are allocated in a loop..."

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

