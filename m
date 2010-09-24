Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0IXJZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:25:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64292 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab0IXJY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HgnqN6Of6hgwWIQEGsqU+C0zmu9q3AGz37LX0ABCo/DSmnbRFhkfwC7G1XGr4TZb+X
         80CNjJ77qCRwTzsFG/ag8F1ebyWTnXwKOuZc2vRZN6i1GYV1y5ptsK/3uB+B3S3GeQWq
         ttzJxP5MSHvb/tRtf+ygDgJ9HAVoTBuU0RLUE=
Date: Fri, 24 Sep 2010 17:29:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Geoffrey Said <geoffrey@2x.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        stable@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Long maintenance kernel versions.
Message-ID: <20100924092929.GC5453@cr0.nay.redhat.com>
References: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
 <20100924053648.GA5453@cr0.nay.redhat.com>
 <AANLkTimDtYF_ZNGvH-UxWrFyMsxjzKfsgyDTJnjt70Hs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimDtYF_ZNGvH-UxWrFyMsxjzKfsgyDTJnjt70Hs@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 07:42:50AM +0200, Geoffrey Said wrote:
>Thanks for the prompt reply,
>
>but this puts us at a disadvantage as we will not know which kernel
>will be long term supported when starting the development process.
>

That is true, unfortunately.


>Take our case for the 34 kernel.  I knew that SuSE were going to use
>the 34 kernel in their 11.3 and since it was the latest we started
>work on the integration.  Now after the work is almost over, we hear
>that it will not be maintained anymore and we need to move to 35.  I
>do not think that this is a good system for people like us which have
>limited resources at their disposal.
>

Why not just pick .32? And backport features from 34 to 32.
That should not be hard.


>Can I suggest that their is a road map and long term maintenance
>kernels are ear marked before hand by the major Linux distributions?
>This will enable us to wait and integrate kernels fully confident that
>they will be long term supported.
>

I think Greg is the right person to answer this question. :)

Thanks!
