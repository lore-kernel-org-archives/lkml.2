Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1E3TpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:45:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1E3TpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:45:03 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=XYJHFtupD_QA:10 a=mh_q4EFMtyMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=8taU_2JZkEQnH2KtYvoA:9 a=CjuIK1q_8ugA:10 a=U62fhAwekXMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 30 May 2011 15:45:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Turning off the incremental diff robot
Message-ID: <20110530194500.GE10792@home.goodmis.org>
References: <4DE3E9E7.8020008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3E9E7.8020008@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
> Hi all,
> 
> With the v3.0 name change I was looking over what might break, and I'm
> seriously considering turning off the incremental diff robot on
> kernel.org.  It's not clear to me that it is actually useful anymore,
> with git and all.

What is the incremental diff robot?

Does it make the patches between 2.6.x to 2.6.x+1?

> 
> Do anyone actually use these anymore?

If the above is the case, yes I do. And we need to update the ketchup
script as well.

-- Steve

