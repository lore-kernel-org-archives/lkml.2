Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2IDHUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:20:11 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3996 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab2IDHUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:20:09 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5045A647.8060904@broadcom.com>
Date: Tue, 4 Sep 2012 09:57:11 +0300
From: "Yuval Mintz" <yuvalmin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:13.0)
 Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "Bjorn Helgaas" <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ariel Elior" <ariele@broadcom.com>,
        "Eilon Greenstein" <eilong@broadcom.com>,
        "Jiang Liu" <jiang.liu@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
References: <20120904115900.9df1ae8f3f608975293dc715@canb.auug.org.au>
In-Reply-To: <20120904115900.9df1ae8f3f608975293dc715@canb.auug.org.au>
X-WSS-ID: 7C5B74CD3NK22970167-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the pci tree got a conflict in
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c between commit
> 8eee694c3e66 ("bnx2x: fix unload previous driver flow when flr-capable")
> from Linus' tree and commit 2a80eebcbf3e ("bnx2x: Use PCI Express
> Capability accessors") from the pci tree.
> 
> The former removes the function updated by the latter, so I just removed
> the function (see below) and can carry the fix as necessary.

Acked-by: Yuval Mintz <yuvalmin@broadcom.com>


