Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1BRJHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:07:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab1BRJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eg/htAr+dCpxzR1XmTkbfPp83PGLDtoWfYW+iZ3cNqLG7rVEvp8UwUMuYV+ZZMCQRH
         8lpknntocC8JqS2UKXiYITfwdcxOpC5Q6ZZkRlFIATd2If1KhtLki5u2nUkW9XPgt4Hq
         OQIgHH44mFYVcirXT2BxIALxlQKEviT9WPLcA=
Date: Fri, 18 Feb 2011 10:07:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: build failure after merge of the workqueues tree
Message-ID: <20110218090725.GA21209@htj.dyndns.org>
References: <20110218145747.f4b26b91.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218145747.f4b26b91.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 18, 2011 at 02:57:47PM +1100, Stephen Rothwell wrote:
> drivers/input/input-polldev.c: In function 'input_polldev_init':
> drivers/input/input-polldev.c:259: error: 'WQ_FREEZEABLE' undeclared (first use in this function)
> 
> Caused by commit 58a69cb47ec6991bf006a3e5d202e8571b0327a4 ("workqueue,
> freezer: unify spelling of 'freeze' + 'able' to 'freezable'") interacting
> with commit 8fb3f6f6bf6e17e97712d216f230ba05f2e88ed8 ("Input:
> input-polldev - create workqueue upfront") from the input tree.
> 
> I applied the following fix up patch (and can carry it as necessary):

Yeah, looks good to me.  I already sent pull request for the rename to
Linus so once it gets pulled, Dmitry should be able to pull in the
mainline and resolve the conflict there.

Thank you.

-- 
tejun
