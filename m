Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146Ab2JXPJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:09:25 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:26376
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964966Ab2JXPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:09:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah107ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1504h1537h153bh1155h)
X-WSS-ID: 0MCEKRD-01-1IK-02
X-M-MSG: 
Date: Wed, 24 Oct 2012 17:09:11 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: <mtk.manpages@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        <konrad.wilk@oracle.com>, <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] Documentation DMA-API-HOWTO.txt Add dma mapping error
 check usage examples
Message-ID: <20121024150911.GC2764@amd.com>
References: <1350230064.4069.1.camel@lorien2>
 <20121018094715.GC5685@mwanda>
 <CAKgNAkhx2trGUMCbpYbKbMYYjq9oTeAnqG436_MP2t6noA3K-g@mail.gmail.com>
 <1350590458.2680.44.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1350590458.2680.44.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:00:58PM -0600, Shuah Khan wrote:
> Enhance the document to discuss the importance of dma mapping error checks
> after dma_map_single() and dma_map_page() calls. Also added usage examples
> that include unmap examples in error paths when dma mapping error is returned.
> Includes correct and incorrect usages to high light some common mistakes in
> error paths especially when dma mapping fails when more than one dma mapping
> call is made.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

