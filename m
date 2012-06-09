Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2FIC6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:58:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2FIC6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:58:51 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=NfCaXVXfj-EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=p1cNtj8pF-fkas_WVBkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339210729.13377.68.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/3 v2] [GIT PULL][3.6] x86: cr2 and cmpxchg issues of
 NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 08 Jun 2012 22:58:49 -0400
In-Reply-To: <20120609020257.248773533@goodmis.org>
References: <20120609020257.248773533@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 22:02 -0400, Steven Rostedt wrote:
> Ingo,
> 
> This is the version 2 with the updates suggested by H. Peter Anvin.
> 
> Please pull the latest tip/x86/core-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/x86/core-2
> 

FYI, I based this off of tip/x86/debug.

-- Steve


