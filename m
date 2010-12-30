Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0L3LYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 06:24:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40009 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0L3LYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 06:24:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bkWYfjtsZWFucLl5XjootgzFYxhbx+XuHZjqYWkVw8jzY8C/lfaVovhuR1wNVg9LFs
         yyOWGGTpoBLR4E3p3yoz5AU43KLUQEZ4sXNUigVPUXso2AdiQcAPgXT3cMbMSJ26TKPz
         Y+CQGqVNTDTe1Fhp1q/y1TwZhKIOx7OsOyTY8=
Date: Thu, 30 Dec 2010 12:23:59 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Use this_cpu_ops to optimize code
Message-ID: <20101230112359.GA18831@htj.dyndns.org>
References: <4D0CD337.4080407@kernel.org>
 <4D100400.7060104@zytor.com>
 <4D1BA867.4070105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1BA867.4070105@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 29, 2010 at 01:30:15PM -0800, H. Peter Anvin wrote:
> I talked this over with Ingo, and Ingo is really unhappy about making
> -tip depend on the percpu tree ... he says "there are enough problems
> with keeping the dependencies working as it is".  As such, it would be
> better if you could take these patches in the percpu tree, with my ack.

Okay, applied these three.  I suppose the same goes for the newer
patches?  I'll ping you there.

Thanks.

-- 
tejun
