Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1DODlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:41:36 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48367 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1DODlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UPlQhH7PBtklwWnfiuPFQW8Coc/SsbW+jtcwS8/2vP3lF/ZxZFzXoF0NY5g+m6PvhO
         9XM2PmaRppj93yVb35mE/ixjBQornck3g3q4fZn9q3k+urcq6YF8KmnE6IHcqxyt7Rap
         NiP/zAsLat4STNaI3Xh3IKsHTduy9gi+3AONo=
Date: Fri, 15 Apr 2011 12:41:29 +0900
From: Tejun Heo <tj@kernel.org>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: Re: [patch v3 1/3] percpu_counter: change return value and add
 comments
Message-ID: <20110415034129.GB29512@mtj.dyndns.org>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
 <20110414020747.006551352@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414020747.006551352@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:04:48AM +0800, shaohua.li@intel.com wrote:
> the percpu_counter_*_positive() API in UP case doesn't check if return value is
> positive. Add comments to explain why we don't.
> Also if count < 0, returns 0 instead of 1 for *read_positive().
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Applied to percpu#for-2.6.40 w/ Eric's Acked-by added.

Thanks.

-- 
tejun
