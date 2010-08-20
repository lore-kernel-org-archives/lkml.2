Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0HTKtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:49:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:54117 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HTKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:49:05 -0400
Date: Fri, 20 Aug 2010 19:43:48 +0900
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, hare@suse.de
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1282298560.30453.370.camel@haakon2.linux-iscsi.org>
References: <1282295674.30453.337.camel@haakon2.linux-iscsi.org>
	<20100820184031L.fujita.tomonori@lab.ntt.co.jp>
	<1282298560.30453.370.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820194231R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 20 Aug 2010 19:43:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 03:02:40 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> review of TCM core and TCM_Loop.   But perhaps at this point LIO-Target
> should go in together with TCM Core and TCM_Loop once mnc can review the
> software iSCSI target pieces..?

I think that James meant that we have only one scsi target
implementation and we need to replace the current in-kernel target
mode driver. So I don't think that we can merge TCM core without its
ibm vscsi driver. I might be wrong though.
