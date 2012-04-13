Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2DMNQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:16:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2DMNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:16:23 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=roI9hkIn2AAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=vddSK0otzzMbXsTu-yAA:9 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Fri, 13 Apr 2012 09:16:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vishal Nandanwar <operational.people@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need help to understand and develop the device drivers
Message-ID: <20120413131621.GA11036@home.goodmis.org>
References: <CAKB833knAUDCk1UhmL64m17OzuM+NnHiZFNzzEtb9jdFwSzXPw@mail.gmail.com>
 <CAKB833mnQbJ-Q_mG3GeUn4dTZs+6PHKwcO=mGDmOJDArrChE7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKB833mnQbJ-Q_mG3GeUn4dTZs+6PHKwcO=mGDmOJDArrChE7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 02:41:29PM +0530, Vishal Nandanwar wrote:
> Hi,
> 
> I am new in Linux device driver development. Currently I am learning
> drivers from the book "Linux device drivers" by Rubini. This book is
> quite big and quite boring. What are the ways to learn the drivers?

What are ways to learn the drivers? By reading really big and boring
books!

I read the "AMD64 Architecture Programmer's Manual Volume 2: System
Programming" from cover to cover. Now *that* was a boring read. But it
was required to be efficient at doing my job.

> 
> Do any one have any guide in video or PPT format or in any other format?
> 

You are obviously clueless to what you are doing. Most people here do
not even own Power Point, nor do they even run Windows (I don't). I'm
happy that Windows developers are interested in learning how to work
with Linux, but I'm disgusted at someone that doesn't want to put the
effort in to learn how to do it the correct way.

Kernel developing in not easy (this includes device drivers) and should
not be taken lightly such that you can start developing after reading
some silly PPT presentation.

If you don't `want to put in the effort to read a "big boring book" to
learn how to develop the correct way, we don't want you developing
drivers for our kernel. Because I can guarantee that your code will be
nothing more than shit.

-- Steve

PS. I don't want to discourage you. If you decide that what you just
asked was really silly, and you figure out that it does take an effort
to do kernel developing, then I welcome you with open arms.

