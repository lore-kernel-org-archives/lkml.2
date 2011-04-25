Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab1DYIVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 04:21:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61413 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab1DYIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 04:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IjRC0YCUnGFHfO+rmeg3w2XTHkj4yFzA9eoXb4GMEVxhImgGNYH3N5Z64X3rn1VeaJ
         UmtEMepJqpYh/PJSd8YCPKGwZ1qGnZsOy82onCgFtSmcNCYlmDf2hD5RvG8uvKEk2Cim
         WW+iQPJCE4u2/fonB+/oyPO8/utDi3BOa97J8=
Date: Mon, 25 Apr 2011 10:21:03 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [RFC]block: add flush request at head
Message-ID: <20110425082103.GA17734@mtj.dyndns.org>
References: <1303112174.3981.187.camel@sli10-conroe>
 <4DABF194.4010603@fusionio.com>
 <1303115157.3981.198.camel@sli10-conroe>
 <20110422225704.GA1576@mtj.dyndns.org>
 <1303693319.3981.272.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303693319.3981.272.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Mon, Apr 25, 2011 at 09:01:59AM +0800, Shaohua Li wrote:
> this is a regression from 2.6.39-rc2 compared to 2.6.39-rc1, so this
> isn't related to the flush rewritten. Workload is sysbench fileio,
> please see the first mail at the thread for detail.

Understood.  Let's talk on the other thread.

Thanks.

-- 
tejun
