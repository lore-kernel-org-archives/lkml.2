Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332Ab2FGS4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:56:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab2FGS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:56:41 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=RcwUMuyEaQwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=8RkEiRJX6qWgLYaZfeUA:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339095399.13377.2.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 3/4] mips-remove-smp-reserve-lock.patch
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ralf Baechle <ralf@linux-mips.org>
Date: Thu, 07 Jun 2012 14:56:39 -0400
In-Reply-To: <4FD0E9F9.60906@gmail.com>
References: <20120607155148.698959275@goodmis.org>
	 <20120607155221.836885041@goodmis.org> <4FD0E9F9.60906@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 10:50 -0700, David Daney wrote:
> On 06/07/2012 08:51 AM, Steven Rostedt wrote:
> > From: Thomas Gleixner<tglx@linutronix.de>
> >
> > Instead of making the lock raw, remove it as it protects nothing.
> 
> I don't know how you guys are managing the RT branch, but this seems 
> quite similar to:
> 
> a3c8b4faeeccb33dbad6969bc9e50bf409f167e7 (MIPS: Cavium: Remove 
> smp_reserve_lock.)

Great! Then we don't need to worry about it :-)

But as it doesn't seem that this patch was marked as stable, we will be
carrying it in -rt where we support older kernels.

Should it go to mainline stable?

-- Steve

> 
> David Daney
> 


