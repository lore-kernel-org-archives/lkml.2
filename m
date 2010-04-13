Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0DMVlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:41:08 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:7309 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0DMVlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:41:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/3] cxgb4i: main driver files
Date: Tue, 13 Apr 2010 14:41:59 -0700
Message-ID: <8A71B368A89016469F72CD08050AD33407AC6530@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] cxgb4i: main driver files
Thread-Index: AcrbSi790HXCeX4bQl6wqonXx/nHuAAB9f4w
References: <1270728855-20951-1-git-send-email-rakesh@chelsio.com> <1270728855-20951-2-git-send-email-rakesh@chelsio.com> <1270728855-20951-3-git-send-email-rakesh@chelsio.com> <4BC4D711.5030802@cs.wisc.edu>
From: "Karen Xie" <kxie@chelsio.com>
To: "Mike Christie" <michaelc@cs.wisc.edu>, <open-iscsi@googlegroups.com>
Cc: "Rakesh Ranjan" <rakesh@chelsio.com>, <netdev@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>, <James.Bottomley@hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike,

Yes, will do that for the next submission.

Thanks,
Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Tuesday, April 13, 2010 1:42 PM
To: open-iscsi@googlegroups.com
Cc: Rakesh Ranjan; netdev@vger.kernel.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Karen Xie; davem@davemloft.net;
James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH 2/3] cxgb4i: main driver files

On 04/08/2010 07:14 AM, Rakesh Ranjan wrote:
> +static inline int cxgb4i_ddp_gl_map(struct pci_dev *pdev,
> +				struct cxgb4i_gather_list *gl)
> +{
> +	int i;
> +
> +	for (i = 0; i<  gl->nelem; i++) {
> +		gl->phys_addr[i] = pci_map_page(pdev, gl->pages[i], 0,
> +						PAGE_SIZE,

Hey Rakesh,

I guess we are trying to move away from the pci mapping functions move 
to the dma ones. On your next submission, could you fix those up too?
