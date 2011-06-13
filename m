Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1FMPOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:14:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1FMPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:14:28 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=nbpwko1cA38A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QzsWEoM40CBg3qrFoh8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Steven Rostedt <rostedt@goodmis.org>
To: habanero@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307977614.17297.12.camel@atheurer-w510>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>  <1307723232.3941.178.camel@twins>
	 <1307977614.17297.12.camel@atheurer-w510>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 11:14:26 -0400
Message-ID: <1307978066.9218.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 10:06 -0500, Andrew Theurer wrote:
> On Fri, 2011-06-10 at 18:27 +0200, Peter Zijlstra wrote:
> > On Fri, 2011-06-10 at 10:34 -0500, Andrew Theurer wrote:
> > > RIP: 0010:[<ffffffff8104e8c1>]  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
> > 
> > If you've still got the vmlinux around, could you find out where in
> > find_lowest_rq that RIP is? 
> 
> Does this help?

A little, but could you also do the following: (if you had DEBUG_INFO
compiled in)

$ gdb vmlinux
gdb> li *0xffffffff8104e8c1

And give the output of that?

Thanks,

-- Steve


