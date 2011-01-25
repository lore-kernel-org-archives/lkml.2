Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1AYNhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:37:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1AYNhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:37:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m57m49FC7GY0rar5TheryP+95WLoL7G4hWQSwT/ibcuJxg1hvvwtBZzQjzNEVASGoC
         A1vH3EqUS9ycZ+nYDyaWP0lZUyCHV+R7+Cj5ZZl8MplavvA/7JNgPVsLdBX71EhraTNm
         ofz5miO2NONvrB8szzSbuQHyBc1uJhlgu4NFo=
Date: Tue, 25 Jan 2011 14:36:56 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH wq#for-2.6.38] workqueue: use WQ_MEM_RECLAIM instead of
 WQ_RESCUER
Message-ID: <20110125133656.GW27510@htj.dyndns.org>
References: <20101231140109.GL18831@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101231140109.GL18831@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 03:01:09PM +0100, Tejun Heo wrote:
> WQ_RESCUER is now an internal flag and should only be used in the
> workqueue implementation proper.  Use WQ_MEM_RECLAIM instead.
> 
> This doesn't introduce any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: dm-devel@redhat.com
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Neil Brown <neilb@suse.de>

Applied to wq#for-2.6.39 sans the redundant gfs2 part.

Thanks.

-- 
tejun
