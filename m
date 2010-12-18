Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0LRHP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 02:15:29 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:35562 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0LRHP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 02:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZN6/6Kb3lz55srCbnTPPjhPyy1la1/LUhNJJ3l9B+awGCyX6ME5Hj135dEbHBYFs3c
         BSfQKMLLNpzPVCfF1J5cwsqJdSzpz87PM854DFsGLYEVR/dq3dvHEk/cdFySLaOrvOgP
         m6I4d0mr87p+forQwYmJFt0M3akA/ARLJLbeg=
Message-ID: <4D0C5F8B.2090704@kernel.org>
Date: Sat, 18 Dec 2010 08:15:23 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: manual merge of the block tree with the  tree
References: <20101217122831.39300d94.sfr@canb.auug.org.au> <1292597607.2820.17.camel@mulgrave.site>
In-Reply-To: <1292597607.2820.17.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On 12/17/2010 03:53 PM, James Bottomley wrote:
> Tejun, could you respin the sd patch on top of SCSI misc, please?  (I
> promise to review it speedily if you do).

Sure, will do later today.  Thanks.

-- 
tejun
