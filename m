Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2AFXYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:24:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222Ab2AFXYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:24:03 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5Kkf9dAxP3YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=fWj1Dhls1UhyQogXruwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325892241.7642.18.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] recordmcount: Fix handling of elf64 big-endian objects.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <david.daney@cavium.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jan 2012 18:24:01 -0500
In-Reply-To: <4F078086.7060208@cavium.com>
References: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com>
		 <1324350542.5916.48.camel@gandalf.stny.rr.com>
	 <4F075CAE.2040709@gmail.com> <1325891377.7642.17.camel@gandalf.stny.rr.com>
	 <4F078086.7060208@cavium.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 15:15 -0800, David Daney wrote:
> On 01/06/2012 03:09 PM, Steven Rostedt wrote:
> > On Fri, 2012-01-06 at 12:42 -0800, David Daney wrote:
> >
> >> Any more feedback on this patch?  Should I look for it to appear in 3.3?
> >
> > OK, I tested it and then I noticed that mainline doesn't have
> > "HAVE_C_RECORDMCOUNT" set. Is that going in the PPC tree?
> 
> I have no idea, I'm a MIPS guy at the moment.
> 

Ah, I forgot about that. Sorry ;)

-- Steve


