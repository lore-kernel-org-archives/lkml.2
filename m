Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1E3PHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:07:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1E3PHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:07:53 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=XYJHFtupD_QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=HCBNgsfdGUPPDC8Y-sQA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 30 May 2011 11:07:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
Message-ID: <20110530150750.GD10792@home.goodmis.org>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
 <201105300359.28515.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105300359.28515.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:59:28AM +0200, Rafael J. Wysocki wrote:
> > 
> > So no ABI changes, no API changes,
> 
> Well, actually there is one. ;-)  The shutdown/suspend/resume callbacks have
> been removed from struct sysdev_class and struct sysdev_driver.

And there's another one. The function tracer now allows different users
to pick different functions to trace! We don't actually have any true
users of that yet (perf will be the first, hopefully in 3.1), but it is
a new feature.

> 
> Not that this is important to anyone except for the 10 people or so who care,
> but still. :-)

I think you have 9 more people that care about your change than mine ;)

-- Steve
