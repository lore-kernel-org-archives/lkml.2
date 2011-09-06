Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1IFQpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:45:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61786 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1IFQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:45:11 -0400
Date: Wed, 7 Sep 2011 01:44:58 +0900
From: Tejun Heo <tj@kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Anton Blanchard <anton@samba.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Message-ID: <20110906164458.GI18425@mtj.dyndns.org>
References: <20110826072622.406d3395@kryten>
 <20110826072927.5b4781f9@kryten>
 <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110829214609.495ee299@kryten>
 <20110906034851.GC18425@mtj.dyndns.org>
 <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EEB2FCE2-3C14-406E-BD0E-FD27D091C492@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 09:30:50AM -0400, Theodore Tso wrote:
> >> I chose to cap percpu_counter_batch at 1024 as a conservative first
> >> step, but we may want to reduce it further based on further benchmarking.
> >> 
> >> Signed-off-by: Anton Blanchard <anton@samba.org>
> > 
> > Applied to percpu/for-3.2.
> 
> Um, this was an ext4 patch and I pointed out it could cause problems.  (Specifically, data loss…)

Ah okay, I thought you were talking about the first patch only.
Reverting for now.

Thanks.

-- 
tejun
