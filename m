Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2HYDHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:07:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24566 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2HYDHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:07:05 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6H6gRWwE8aEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=jUOLdE365IKNP3ht1wcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345864023.19067.3.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.2.27-rt40
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Date: Fri, 24 Aug 2012 23:07:03 -0400
In-Reply-To: <1345862254.19067.0.camel@gandalf.local.home>
References: <1345862254.19067.0.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 22:37 -0400, Steven Rostedt wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.2.27-rt40 stable release.

Bah, Evolution is crashing on my /tmp directory (where my scripts place
the files). There's a bug in the gtk4 file manager (I'm using xfce),
where if the directory changes it crashes the entire app :-p. Thus I
moved the output file to another directory to post. But I copied an old
version (we're at 3.2.28-rt41 now).

Ignore this announcement, I'll send out another one :-(

-- Steve

> 
> 
> This release is just an update to the new stable 3.2.27 version
> and no RT specific changes have been made.
> 
> 
> You can get this release via the git tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
> 
>   Head SHA1: 31f85ffc3a341b9377ac66702947bbc0e5ca008d
> 
> 
> Or to build 3.2.27-rt40 directly, the following patches should be applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz
> 
>   http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.27.xz
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.27-rt40.patch.xz
> 
> 
> 
> Enjoy,
> 
> -- Steve
> 
> 


