Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab1BVFUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:20:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46968 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1BVFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:20:40 -0500
Message-ID: <4D63479F.3060603@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 21:20:31 -0800
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Eric Van Hensbergen <ericvh@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v9fs tree
References: <20110222115340.da48b908.sfr@canb.auug.org.au>
In-Reply-To: <20110222115340.da48b908.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/2011 4:53 PM, Stephen Rothwell wrote:
> Hi Eric,
> 
> After merging the v9fs tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "p9_payload_gup" [net/9p/9pnet_virtio.ko] undefined!
> ERROR: "p9_nr_pages" [net/9p/9pnet_virtio.ko] undefined!
> ERROR: "p9_release_req_pages" [net/9p/9pnet_virtio.ko] undefined!

These functions are defined by commit 249951bf66816128a7698caa826425e299494c82
([net/9p] Preparation and helper functions for zero copy)

Thanks,
JV

> 
> Caused by commit ac8c81621fe5176f1bb18730e5db2e347af08255 ("[net/9p] Add
> gup/zero_copy support to VirtIO transport layer").
> 
> I have used the v9fs tree from next-20110221 for today.


