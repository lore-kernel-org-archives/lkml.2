Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1ACOUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:20:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1ACOU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:20:29 -0500
Subject: Re: [PATCH 24/32] dlm: dlm workqueues aren't used in memory
 reclaim path
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <20110103140107.GP18831@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-25-git-send-email-tj@kernel.org>
	 <1294063107.2429.34.camel@dolmen>  <20110103140107.GP18831@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 03 Jan 2011 14:21:29 +0000
Message-ID: <1294064489.2429.58.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-01-03 at 15:01 +0100, Tejun Heo wrote:
> On Mon, Jan 03, 2011 at 01:58:27PM +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > You already acked a patch to do this, which is in the DLM git tree,
> > waiting for the next merge window:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/teigland/dlm.git;a=commitdiff;h=dcce240ead802d42b1e45ad2fcb2ed4a399cb255
> 
> Ooh, I see.  Hmmm... maybe I've asked this before but do you really
> need WQ_MEM_RECLAIM there?  Is dlm used during memory reclaim?
> 
> Thanks.
> 

Yes, it is in case of deallocation of inodes, so we have to be careful
about that,

Steve.


