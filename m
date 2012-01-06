Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab2AFVrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:47:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2AFVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:47:40 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5Kkf9dAxP3YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=oAuBdIl4mfn7YCp4yRAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325886457.7642.13.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] recordmcount: Fix handling of elf64 big-endian objects.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Date: Fri, 06 Jan 2012 16:47:37 -0500
In-Reply-To: <4F075CAE.2040709@gmail.com>
References: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com>
	 <1324350542.5916.48.camel@gandalf.stny.rr.com> <4F075CAE.2040709@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 12:42 -0800, David Daney wrote:

> Any more feedback on this patch?  Should I look for it to appear in 3.3?

Crap, I started testing this, and then got sidetracked on some fires I
had to put out, and then x-mas came and I got drunk and forget
everything before that ;)  (not to mention the drugs I was on for my
recent hip surgery)

Let me boot up my PPC64 box and test it out now.

Thanks for the reminder. After I get this done, then I'll push this
through my "urgent" branch, which will go into the rc releases, and I'll
probably add a "stable" tag to it as well.

-- Steve


