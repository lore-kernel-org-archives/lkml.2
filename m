Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1BCJYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:24:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1BCJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:24:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K5OM7EM5pWWqRQ+MUDRFVtrqQZg0NdFl+J2FGPS06l+cG+NbjEyNZ2Gc0RR+8hAIeq
         2lDiqPgUL7TBOAUSjBwiT3pGSJYE1+EyLdJaBtmqYsm79VglsFsMQGMQ0chHIBAmjBPM
         9a747WOPondgnsTzDGMtszVmDQegD3lqdf90E=
Date: Thu, 3 Feb 2011 10:24:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, tytso@mit.edu, djwong@us.ibm.com,
        shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com, jmoyer@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH v2 2/2] block: share request flush fields with
 elevator_private
Message-ID: <20110203092401.GA2570@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-2-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296600373-6906-2-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 05:46:13PM -0500, Mike Snitzer wrote:
> Flush requests are never put on the IO scheduler.  Convert request
> structure's elevator_private* into an array and have the flush fields
> share a union with it.
> 
> Reclaim the space lost in 'struct request' by moving 'completion_data'
> back in the union with 'rb_node'.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
