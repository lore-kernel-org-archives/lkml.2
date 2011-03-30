Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1C3NFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:05:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1C3NFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:05:35 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=6e3NE4ipf18A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=aIzfbH8M4opDCJzU2mEA:9 a=OESqZY25dACZSNSjGeQA:7 a=hwY_VtllnaERwX-ldE7IBRPjluEA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 30 Mar 2011 09:05:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: jmheo <jongman.heo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compile error with 2.6.39-rc1 (in arch/x86/kernel/apb_timer.c)
Message-ID: <20110330130532.GH8529@home.goodmis.org>
References: <loom.20110330T040947-18@post.gmane.org>
 <20110330022138.GG8529@home.goodmis.org>
 <loom.20110330T044159-684@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20110330T044159-684@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, the Linux kernel mailing list gets over 600 emails a day. I do not
read all of them, but I do skim through. By not including me in the
reply, I will most likely never see this message again. Always do a reply
all on LKML.

On Wed, Mar 30, 2011 at 02:43:55AM +0000, jmheo wrote:
> > 
> > Could you post your full config please.
> > 
> > Thanks,
> > 
> 
> Here it is, thanks.
> 

As others have posted, it seems that an allmodconfig produces the same
error and there's already a fix.

Thanks,

-- Steve

