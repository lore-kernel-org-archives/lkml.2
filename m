Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab2C2RYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:24:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab2C2RX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:23:56 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ujHqK8gl_DAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=swt5PWyrT_LeX1jwsxkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1333041834.23924.186.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 29 Mar 2012 13:23:54 -0400
In-Reply-To: <alpine.LFD.2.02.1203291914040.10113@tycho>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
	 <alpine.LFD.2.02.1203291902280.10113@tycho> <20120329171140.GE6409@aftab>
	 <alpine.LFD.2.02.1203291914040.10113@tycho>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 19:17 +0200, John Kacur wrote:
> 

> It looks okay to me. Technically it's not functionally equivalent though, 
> because now when __register_ftrace_function is called directly, (in other 
> paths), the test has an unlikely there. See what Steven says, otherwise, 
> you can have my reviewed by.

Unlikely()s shouldn't affect things functionally, its just an
optimization hint.

Also, this check is unlikely to be true, so the hint is valid here.

-- Steve


