Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1ACOBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:01:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64430 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1ACOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:01:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JV0lkVdfPQDbOX8baI1Da/wpd7IhDfa1mLVHmt8sNYai4e2kdQX6OshPKieNXKh2r6
         3vDperdb1x6bG1FzluBmIMli8V2l/5cq9DYHyWFrnGWLuN7flMlsjvoEeLxdcyQWDKTg
         gxFLu+CPOtO+2eWojkEm3PzPkT5JJfaTA2yis=
Date: Mon, 3 Jan 2011 15:01:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 24/32] dlm: dlm workqueues aren't used in memory
 reclaim path
Message-ID: <20110103140107.GP18831@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-25-git-send-email-tj@kernel.org>
 <1294063107.2429.34.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294063107.2429.34.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 01:58:27PM +0000, Steven Whitehouse wrote:
> Hi,
> 
> You already acked a patch to do this, which is in the DLM git tree,
> waiting for the next merge window:
> 
> http://git.kernel.org/?p=linux/kernel/git/teigland/dlm.git;a=commitdiff;h=dcce240ead802d42b1e45ad2fcb2ed4a399cb255

Ooh, I see.  Hmmm... maybe I've asked this before but do you really
need WQ_MEM_RECLAIM there?  Is dlm used during memory reclaim?

Thanks.

-- 
tejun
