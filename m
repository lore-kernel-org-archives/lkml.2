Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1FNAfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:35:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab1FNAfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:35:45 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=nbpwko1cA38A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BjAo3GHOZZvjUevs1r4A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Steven Rostedt <rostedt@goodmis.org>
To: habanero@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1308009910.23688.34.camel@atheurer-ubuntu10>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>  <1307723232.3941.178.camel@twins>
	 <1307977614.17297.12.camel@atheurer-w510>
	 <1307979239.9218.76.camel@gandalf.stny.rr.com>
	 <1308009910.23688.34.camel@atheurer-ubuntu10>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 20:35:42 -0400
Message-ID: <1308011742.9218.103.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 19:05 -0500, Andrew Theurer wrote:

> > Could you try this patch?
> 
> Yes, and it works!  Thanks very much!
> > 
> >

Great! I'll make a patch up. Can I add your reported-by and tested-by
tags?

-- Steve


