Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2IMUVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:21:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16068 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab2IMUVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:21:07 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cpJQsIBz2fcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CGgBco54DJ0A:10 a=VwQbUJbxAAAA:8 a=ieozS7MuqSy_348GjZkA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347567662.10751.84.camel@gandalf.local.home>
Subject: Re: [PATCH RT 0/2] [ANNOUNCE] 3.0.42-rt64-rc1 stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 13 Sep 2012 16:21:02 -0400
In-Reply-To: <20120913185234.912247144@goodmis.org>
References: <20120913185234.912247144@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 14:52 -0400, Steven Rostedt wrote:

> ----
> Note: The patches have not been uploaded to kernel.org yet. I've
> recently changed the subkey that I use to sign the patches as the
> old subkey is about to expire. But unfortunately, kernel.org has
> not updated its key ring, and is refusing my current subkey.
> 
> I have a ticket open with kernel.org to resolve the issue. But until
> then, this mailing is the only place the patches exist.
> ----

Issue is solved, patches are up.

-- Steve

> 
> To build 3.0.42-rt64-rc1 directly, the following patches should be applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz
> 
>   http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.42.xz
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.42-rt64-rc1.patch.xz
> 
> You can also build from 3.0.42-rt63 by applying the incremental patch:
> 
> http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.42-rt63-rt64-rc1.patch.xz
> 
> 


