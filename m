Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1ELI71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:59:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64379 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1ELI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZoRBPTEofD1p5nx4lhl7uzy3y53oQg+cAQpk2E5oY95pqm8a6OuvN38ZtdTWfehzn4
         ou6ueY68voQG5A7/YY6/A3VTgieaA/hDS4uUQR3sAw+yS7pq4t6WRLyVP+HDhcju5Y8y
         j6kUTh8wwfiQZkh9wzJ1ub01eFwu21+7yNHxE=
Date: Thu, 12 May 2011 10:59:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
Message-ID: <20110512085922.GD1030@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
 <20110511092848.GE1661@htj.dyndns.org>
 <1305168493.2373.15.camel@sli10-conroe>
 <20110512082159.GB1030@htj.dyndns.org>
 <1305190520.2373.18.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305190520.2373.18.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 04:55:20PM +0800, Shaohua Li wrote:
> sure, but it's quite difficult to determine a @maxfuzzy in his proposal
> I thought (and could confuse user), did I miss anything?

I don't think @maxfuzzy is necessary there.  I wrote this before but
why can't we track the actual deviation instead of the number of
deviation events?

Thanks.

-- 
tejun
