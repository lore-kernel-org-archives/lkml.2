Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1FUBaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:30:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1FUBaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:30:10 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=XYJHFtupD_QA:10 a=Mm2usJTNaYsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=k-MBkcLGMU1Mezgd42IA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 20 Jun 2011 21:30:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: fix  jump_label update
Message-ID: <20110621013007.GH27245@home.goodmis.org>
References: <4DFBB2D5.2060003@cn.fujitsu.com>
 <20110621003934.GG27245@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621003934.GG27245@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 08:39:35PM -0400, Steven Rostedt wrote:
> On Sat, Jun 18, 2011 at 04:02:29AM +0800, Xiao Guangrong wrote:
> > The key of module is out of __stop___jump_table, it causes the events
> > of modules does not work
> > 
> > This bug is introduced by commit: 7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d
> 
> What exactly breaks? I just tried events in modules, and they still work
> for me.

OK, it does break for me. I tested with CONFIG_JUMP_LABEL not set :-p

Please Cc me on further patches.

Thanks,

-- Steve

