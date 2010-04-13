Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0DMUmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:42:05 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47204 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0DMUmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:42:01 -0400
Message-ID: <4BC4D711.5030802@cs.wisc.edu>
Date: Tue, 13 Apr 2010 15:41:53 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Rakesh Ranjan <rakesh@chelsio.com>, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kxie@chelsio.com, davem@davemloft.net,
       James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH 2/3] cxgb4i: main driver files
References: <1270728855-20951-1-git-send-email-rakesh@chelsio.com> <1270728855-20951-2-git-send-email-rakesh@chelsio.com> <1270728855-20951-3-git-send-email-rakesh@chelsio.com>
In-Reply-To: <1270728855-20951-3-git-send-email-rakesh@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
