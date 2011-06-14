Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1FNMZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:25:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1FNMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:25:50 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=nbpwko1cA38A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JQ0DxSGID0Y6eqs91tUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: habanero@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1308049321.19856.15.camel@twins>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>  <1307723232.3941.178.camel@twins>
	 <1307977614.17297.12.camel@atheurer-w510>
	 <1307979239.9218.76.camel@gandalf.stny.rr.com>
	 <1308009910.23688.34.camel@atheurer-ubuntu10>
	 <1308014683.9218.107.camel@gandalf.stny.rr.com>
	 <1308049321.19856.15.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Jun 2011 08:25:47 -0400
Message-ID: <1308054347.9218.112.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 13:02 +0200, Peter Zijlstra wrote:
> On Mon, 2011-06-13 at 21:24 -0400, Steven Rostedt wrote:
> > On Mon, 2011-06-13 at 19:05 -0500, Andrew Theurer wrote:
> > 
> > > > Could you try this patch?
> > > 
> > > Yes, and it works!  Thanks very much!
> > 
> > Could you try this patch instead? I don't like holding off migration for
> > the entire boot processes.
> 
> Great, thanks Steve!, will you be sending this Ingo-wards?
> 

Yeah, I'll send it off. I have another small scheduling patch to send
for 3.0.

-- Steve


