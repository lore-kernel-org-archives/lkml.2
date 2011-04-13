Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1DMFSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 01:18:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55401 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1DMFSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 01:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o5hNRHizOmzcFryb8HAWgzEVy918INekeb1ecBQ/x88UDdy0QSe8GNWX8mpQPbRL9y
         /Fhhdb6OXIw4lxgaRGLyDZNzpvBVbb+IlkVbyeFpFh7YPGVQ3a9pIjSu3XhH9r27bQRc
         uH0n5Whr7ijcDlCG6X0pyyC1BugIKSSXKwy18=
Date: Wed, 13 Apr 2011 14:18:46 +0900
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110413051846.GD24161@mtj.dyndns.org>
References: <1302617212.2661.14.camel@dolmen>
 <1302621261.2604.18.camel@mulgrave.site>
 <1302624266.2661.21.camel@dolmen>
 <1302625621.2604.24.camel@mulgrave.site>
 <1302627097.2661.25.camel@dolmen>
 <1302630090.2604.30.camel@mulgrave.site>
 <1302633208.2661.29.camel@dolmen>
 <1302638216.2604.35.camel@mulgrave.site>
 <1302640226.2661.34.camel@dolmen>
 <1302641036.2604.40.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302641036.2604.40.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 12, 2011 at 03:43:56PM -0500, James Bottomley wrote:
> Heh, you're welcome, but this is for some value of debug.  There's still
> something strange going on on your box causing extreme delays in the way
> we do stuff.  I took advantage of the delays to explore some races in
> block and SCSI, which is what got fixed .. I've still no idea what the
> actual root cause of the delays is.

A lot of thanks for tracking down all the issues.  Something is
definitely strange with Steven's setup tho.

> Now we need to huddle and decide what we're doing in block and SCSI.  I
> think Tejun's patch with the moved signal for queue destruction patch
> would probably work as well.

Steven, can you be enticed to try the combination?  I'll prep a
combined patch and post it but please beware that I'm currently in a
rather zombish state - sleep deprived, jet lagged and malfunctioning
digestion - so the likelihood of doing something stupid is pretty
high.

Thanks.

-- 
tejun
