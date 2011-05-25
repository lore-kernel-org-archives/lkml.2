Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab1EYQrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:47:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab1EYQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:47:47 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=inQdEuNhf_oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=xnDmk-feDmg-KTid1UMA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid
 warnings on 32bit machine
From: Steven Rostedt <rostedt@goodmis.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: liubo <liubo2009@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20110525091252.8899385e.randy.dunlap@oracle.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
	 <1303150309.7181.51.camel@gandalf.stny.rr.com>
	 <4DACE6E0.7000507@cn.fujitsu.com> <4DBA8C95.4000300@cn.fujitsu.com>
	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>
	 <4DDDE9E6.7090303@cn.fujitsu.com>
	 <1306326464.1465.85.camel@gandalf.stny.rr.com>
	 <20110525091252.8899385e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 12:47:44 -0400
Message-ID: <1306342064.1465.101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 09:12 -0700, Randy Dunlap wrote:
>  
> > But what I sent out previously is not going into 2.6.40 anyway. Ingo
> > feels that it's too late in the merge window to pull those changes and
> > wants to wait till the next merge window. Since there's some fixes in
> > that pull request, I'll need to cherry pick them out and rebase the rest
> > for the next window.
> 
> Sorry to hear all of that.  This fix is needed in mainline.
> 

Hmm, it is a warning fix. Well, I could add this to the cherry picking
I'm doing (fixes only).

I'm currently making a fix for a triple fault in the function tracer
caused by PROVE_RCU causing recursive tracing. When I get this fixed,
I'll be pushing the "fixes" next.

Thanks!

-- Steve


