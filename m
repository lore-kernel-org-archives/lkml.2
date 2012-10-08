Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2JHXXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:23:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2JHXXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:23:42 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=2bXsuTSFsZPLnirZKZgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349738619.24256.1.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.12-rt20
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 08 Oct 2012 19:23:39 -0400
In-Reply-To: <CAP=VYLrg2ouS+fODQMtxAguZ84h-v5T66aX48vTOCdsMhbBckg@mail.gmail.com>
References: <1349720414.6755.111.camel@gandalf.local.home>
	 <CAP=VYLrg2ouS+fODQMtxAguZ84h-v5T66aX48vTOCdsMhbBckg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 19:05 -0400, Paul Gortmaker wrote:
> On Mon, Oct 8, 2012 at 2:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Dear RT Folks,
> >
> > I'm pleased to announce the 3.4.12-rt20 stable release.
> >
> >
> > This release is just an update to the new stable 3.4.12 version
> > and no RT specific changes have been made.
> 
> Did I miss something that ruled out the inclusion of your fix for
> moving the per-cpu softirq lock init after setup_per_cpu_areas?
> 

Nope, this was just a stable release. I keep stable merges separate from
added -rt patches. I need to add that, but I was waiting on more patches
coming from Thomas as he releases the 3.6-rt release (hopefully soon ;-)

-- Steve


