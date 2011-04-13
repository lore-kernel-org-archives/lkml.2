Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1DMS7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:59:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50919 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab1DMS7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vtG66z5jA0xJd1sZ9kbAoHgVRvfMLdHN51khGUTLSXsuNWyUVUUGi5UFrYxrlpqF5C
         042d2trh0mPBOgGHnGkVCEitqDgG4RRt7cq6QCwMI9wbRxq+BI2kbXqP0AhoSn+CnN3p
         KxAMqT8NWckmspDZyvCZzZ0krD9rY6KgSrYIg=
Date: Thu, 14 Apr 2011 03:59:23 +0900
From: Tejun Heo <tj@kernel.org>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: Re: [patch v2 2/4] percpu_counter: delete dead code
Message-ID: <20110413185923.GB3987@mtj.dyndns.org>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
 <20110413080517.566936500@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413080517.566936500@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:57:17PM +0800, shaohua.li@intel.com wrote:
> percpu_counter_sum_positive never returns negative.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Can you please send this to ext4? - linux-ext4@vger.kernel.org and
"Theodore Ts'o" <tytso@mit.edu>.

Thanks.

-- 
tejun
