Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AYQuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:50:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60554 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1AYQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JYJ70XQkfLfaBRATdmts+Q8g6xdTeDu1hbYB/JXMws0tc+6up5vKw9gXij1Co/XoCQ
         lY5L9L9KZz1ECtLxoUKWLrU+W3aC3nMCl1R6ncXNtfmDR7+7RQSGHSov4mAFtML3UNuz
         eQdzPFuNbB3vEwWyp3djKDGdqtFiIC8/gfydU=
Date: Tue, 25 Jan 2011 08:50:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: Tejun Heo <tj@kernel.org>, Dan Carpenter <error27@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 10/32] input/tps6507x-ts: use system_wq instead of
 dedicated workqueue
Message-ID: <20110125165005.GB19701@core.coreip.homeip.net>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-11-git-send-email-tj@kernel.org>
 <20110103143926.GX1886@bicker>
 <4D21FAA3.8030505@ridgerun.com>
 <20110125141942.GA27510@htj.dyndns.org>
 <4D3EF6B9.6080608@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3EF6B9.6080608@ridgerun.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 09:13:45AM -0700, Todd Fischer wrote:
> On 01/25/2011 07:19 AM, Tejun Heo wrote:
> >Shall I apply the patch?
> >Thanks
> Yes, apply the patch.  I am not sure of the syntax for attaching my
> sign off.  Hope this is okay.
> 
> Todd
> 
> Signed-off-by: Todd Fischer<todd.fischer@ridgerun.com>
> 

That should be Acked-by since you are not passing the patch along.

Fine with the as well.

Thanks.

-- 
Dmitry
