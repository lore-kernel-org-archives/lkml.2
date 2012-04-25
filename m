Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2DYDcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:32:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab2DYDcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:32:35 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=eegaJL_oNbcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VS8-4_CNINlIVZqaREIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335324751.28106.150.camel@gandalf.stny.rr.com>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
From: Steven Rostedt <rostedt@goodmis.org>
To: Minho Ban <mhban@samsung.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 23:32:31 -0400
In-Reply-To: <4F976DC0.6060004@samsung.com>
References: <4F969E53.9080307@samsung.com>
	 <1335272025.28150.193.camel@twins> <4F9737CC.6010703@samsung.com>
	 <20120424234513.GA11841@leaf> <4F976DC0.6060004@samsung.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 12:21 +0900, Minho Ban wrote:
> > 
> > Or, how about declaring get_parent_ip with the GCC "pure" attribute?
> > That would tell GCC that it can safely eliminate calls to the function.
> > 
> > - Josh Triplett
> > 
> 
> Thank you for alternative method, but I'm afraid this could not cover the CALLER_ADDR.

That's fine. I personally prefer the macro with the comment as that is
not as subtle of a fix. It's the most straight forward.

-- Steve


