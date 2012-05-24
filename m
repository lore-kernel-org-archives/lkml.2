Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab2EXQml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:42:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab2EXQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:41:51 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ujHqK8gl_DAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=dJTq37dZ9lB3xvUrRzcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337877710.13348.179.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 24 May 2012 12:41:50 -0400
In-Reply-To: <20120524163246.GL27063@aftab.osrc.amd.com>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
	 <alpine.LFD.2.02.1203291902280.10113@tycho> <20120329171140.GE6409@aftab>
	 <20120524163246.GL27063@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 18:32 +0200, Borislav Petkov wrote:
> Yo Steve,
> 
> want to pick this one up? It still applies cleanly to current linus.

I actually have it in my 3.6 queue. It didn't look like it was urgent
for 3.5. Is it?

-- Steve

> 
> Thanks.
> 
> On Thu, Mar 29, 2012 at 07:11:40PM +0200, Borislav Petkov wrote:
> > On Thu, Mar 29, 2012 at 07:03:23PM +0200, John Kacur wrote:
> > > If you're going to do this, then you can drop the label too.
> > 
> > Jahaa... thanks.
> > 
> > Here's an updated patch:
> > 
> > --
> >

