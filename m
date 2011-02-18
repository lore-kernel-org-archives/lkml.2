Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1BRJtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:49:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33372 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1BRJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=LjGKN2Pu6X+GF8QlMdwp4HxiSu+ii2lDcvI1WCnaZnuA6LxrlLE2vswzyONyGgwNkf
         sV6tNKXbBXOZO0CuXDGj55j+TGEsSmXrd3kOOBEar1QaUKlfIkwL64HQXb6+s8x4l8GA
         OMVc0e6kNXr2sWxk7eIVcq/AaG5GtIhqHD/Yg=
Date: Fri, 18 Feb 2011 10:49:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Beulich <JBeulich@novell.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call
 directly into q->request_fn() __blk_run_queue()
Message-ID: <20110218094903.GF21209@htj.dyndns.org>
References: <20110217111511.GQ19830@htj.dyndns.org>
 <20110217111619.GR19830@htj.dyndns.org>
 <AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:01:51AM -0500, Mike Snitzer wrote:
> Hi Tejun,
> 
> On Thu, Feb 17, 2011 at 6:16 AM, Tejun Heo <tj@kernel.org> wrote:
> 
> > Jens, this is applicable to v2.6.37 and 38.  The new implementation
> > for 39 would need similar fix but I couldn't find where the tree is.
> > Which branch is it?
> 
> for-2.6.39/core

Right, thanks.  Jens, after you apply the two fixes for 2.6.38, I can
create a merge branch for for-2.6.39/core which you can pull.  Would
that work for you?

Thanks.

-- 
tejun
