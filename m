Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0KOQZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:25:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:12348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab0KOQZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:25:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,200,1288594800"; 
   d="scan'208";a="677619042"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Nov 2010 08:24:22 -0800
Subject: RE: [PATCH 14/44] drivers/net/ixgbe: Remove unnecessary semicolons
Thread-Topic: [PATCH 14/44] drivers/net/ixgbe: Remove unnecessary semicolons
Thread-Index: AcuEcftvdxmC6VgnRT2RlEslHutcHgAb4Qcg
Message-ID: <43F901BD926A4E43B106BF17856F0755013080DEFF@orsmsx508.amr.corp.intel.com>
References: <cover.1289789604.git.joe@perches.com>
 <7d2c334daa75c5221946a17d45c9de1901cf06e7.1289789604.git.joe@perches.com>
In-Reply-To: <7d2c334daa75c5221946a17d45c9de1901cf06e7.1289789604.git.joe@perches.com>
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

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Sunday, November 14, 2010 7:05 PM
> To: Jiri Kosina
> Cc: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P;
> Duyck, Alexander H; Ronciak, John; e1000-devel@lists.sourceforge.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 14/44] drivers/net/ixgbe: Remove unnecessary semicolons
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ixgbe/ixgbe_sriov.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ixgbe/ixgbe_sriov.c
> b/drivers/net/ixgbe/ixgbe_sriov.c
> index 5428153..93f40bc 100644
> --- a/drivers/net/ixgbe/ixgbe_sriov.c
> +++ b/drivers/net/ixgbe/ixgbe_sriov.c
> @@ -68,7 +68,7 @@ static int ixgbe_set_vf_multicasts(struct ixgbe_adapter
> *adapter,
>  	 * addresses
>  	 */
>  	for (i = 0; i < entries; i++) {
> -		vfinfo->vf_mc_hashes[i] = hash_list[i];;
> +		vfinfo->vf_mc_hashes[i] = hash_list[i];
>  	}
> 
>  	for (i = 0; i < vfinfo->num_vf_mc_hashes; i++) {
> --
> 1.7.3.1.g432b3.dirty

Acked By: Greg Rose <Gregory.v.rose@intel.com>

