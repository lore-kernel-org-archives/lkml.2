Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030411Ab2AFPrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:47:43 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:22191
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030320Ab2AFPrl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:47:41 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzzz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Cong Wang <amwang@redhat.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, Greg KH <greg@kroah.com>
Subject: RE: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
Thread-Topic: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
Thread-Index: AQHMzEaOre8XCgkPZkCXEcc19C9vx5X/e/sQ
Date: Fri, 6 Jan 2012 15:47:31 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CD04FEB@TK5EX14MBXC222.redmond.corp.microsoft.com>
References: <20120106184055.3669727def69e424cd98690d@canb.auug.org.au>
In-Reply-To: <20120106184055.3669727def69e424cd98690d@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Friday, January 06, 2012 2:41 AM
> To: Cong Wang
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Haiyang Zhang;
> KY Srinivasan; Greg KH
> Subject: linux-next: manual merge of the kmap_atomic tree with the staging
> tree
> 
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got conflicts in
> drivers/net/hyperv/netvsc_drv.c and drivers/net/hyperv/rndis_filter.c between
> commit 453263421f88 ("net/hyperv: Remove unnecessary kmap_atomic in
> netvsc driver") from the staging tree and commit e91cd643d15d ("hv:
> remove the second argument of k[un]map_atomic()") from the kmap_atomic
> tree.
> 
> The former removed the code modified by the latter, so I did that.

Good! Thank you for the merging.

- Haiyang


