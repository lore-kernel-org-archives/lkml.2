Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1EaKeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:34:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1EaKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:34:35 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=XYJHFtupD_QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=o2_-LRUlJRbQQTrOliwA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 31 May 2011 06:34:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
Message-ID: <20110531103431.GA5852@home.goodmis.org>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
 <1306821578.7481.646.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306821578.7481.646.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:59:38PM +1000, Benjamin Herrenschmidt wrote:
> So a bit of bike shedding :-)

Here's where I store my bike.

> 
> Why don't we just keep the 3 digits ? You release 3.x.0 and Greg
> increments the last one ?
> 
> That means existing tools don't break, and number of digits doesn't
> change all the time anymore, less likely to get wrong...
> 

I think the problem with that is that it's still going to break scripts.
The changes in Greg's repo is a fork of Linus's kernel. Thus 3.0.1 will
not be an incremental step into 3.1.0. We wont be having patches that
take us from 3.0.1 to 3.1.0, so things like ketchup will break when it
tries to do such a thing without changing the way it currently works.

If we need to change ketchup (and other scripts) to handle this
difference, might as well do it correctly.

-- Steve

