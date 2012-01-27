Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2A0Tbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:31:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2A0Tbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:31:35 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=YuO6iUK6s4AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=nAZpAcOWgCNCb6R3ZxkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327692694.22710.128.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace-cmd: fix length calculation for padding events
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, chavey@google.com,
        Gregory Haskins <gregory.haskins@gmail.com>
Date: Fri, 27 Jan 2012 14:31:34 -0500
In-Reply-To: <CAJL_eksfxza82jy62NUPmZGtQ77LVuHk+RnN3F95s-hSaSpK2w@mail.gmail.com>
References: <1327633215-4013-1-git-send-email-dhsharp@google.com>
	 <1327635873.22710.113.camel@gandalf.stny.rr.com>
	 <CAJL_eksfxza82jy62NUPmZGtQ77LVuHk+RnN3F95s-hSaSpK2w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 11:21 -0800, David Sharp wrote:

> > Nice catch!  I wonder how long this has been around without notice?
> > Probably from day one.
> 
> Yeah, I think so. It's an easy mistake to make, because it's
> incongruent with the rest of the event types.

Yeah, I admit, that was a flaw in the buffer design. :-/

-- Steve


