Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0HDQKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:10:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53232 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab0HDQKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:10:09 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Aug 2010 21:39:51 +0530
Subject: RE: linux-next: manual merge of the davinci tree with Linus' tree
Thread-Topic: linux-next: manual merge of the davinci tree with Linus' tree
Thread-Index: Acsyrguxk8hxm2ZfQxq9aZfcsf4CcQBQSSIg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301E7F6ED59@dbde02.ent.ti.com>
References: <20100803114853.27a29365.sfr@canb.auug.org.au>
In-Reply-To: <20100803114853.27a29365.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Aug 03, 2010 at 07:18:53, Stephen Rothwell wrote:
> Hi Kevin,
>
> Today's linux-next merge of the davinci tree got a conflict in
> arch/arm/mach-davinci/board-da850-evm.c between commit
> 8b24599e72c9aee1ea1187e29cb9c5de9f449cce ("davinci: da850/omap-l138 evm:
> account for DEFDCDC{2,3} being tied high") from Linus' tree and commit
> ebd1e7808b2fe72d627bdab7bcf61126a831ca5a ("davinci: da850 evm: sparse
> cleanup: make file local variables static") from the davinci tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

Thanks for fixing this.

Kevin is on a vacation. There would be a delayed response.

Regards,
Sekhar
