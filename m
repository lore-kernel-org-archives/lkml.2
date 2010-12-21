Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab0LULXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:23:03 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:41913 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0LULXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mpWZBeKYc9/0+f1eVCq+7rPkBGjHNp/56ia+i1N3fu9aMlLDRlUR8PGB/0LMpBJ+9g
         JFbxNvzOOLJvI+2DXrqM+0fX+vyLfMwYu4g0HpTf2MlQDNkg3l7g/MKb7xUBtiPRDCwZ
         zLz1X3mppiCXOQH87Crv9rfCAiHA0126Oi1lg=
Date: Tue, 21 Dec 2010 12:22:54 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Use this_cpu_ops to optimize code
Message-ID: <20101221112252.GB3515@htj.dyndns.org>
References: <4D0CD337.4080407@kernel.org>
 <4D100400.7060104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D100400.7060104@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 20, 2010 at 05:33:52PM -0800, H. Peter Anvin wrote:
> On 12/18/2010 07:28 AM, Tejun Heo wrote:
> > Peter, these three patches are the x86 ones which were in
> > percpu#for-next but should go through x86 tree.  These should be
> > applied on top of percpu#this_cpu_ops.
> 
> Does that mean the latter is now a stable base that I can pull into -tip?

Yes, #for-next may be rebased but both #this_cpu_ops and #for-2.6.38
are stable branches.

Thank you.

-- 
tejun
