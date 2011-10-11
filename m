Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1JKA3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:29:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35037 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1JKA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:29:21 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=aA5YmrGhA0mQ1SE5Us0A:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: stable mailing list?
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Oct 2011 20:29:20 -0400
In-Reply-To: <20111011000759.GA28709@suse.de>
References: <1318290984.7904.127.camel@gandalf.stny.rr.com>
	 <20111011000759.GA28709@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318292960.7904.129.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 17:07 -0700, Greg KH wrote:
> On Mon, Oct 10, 2011 at 07:56:23PM -0400, Steven Rostedt wrote:
> > I received a bounce from stable@kernel.org. What should we be Ccing to?
> 
> You should be marking your patch with a:
> 	Cc: stable <stable@kernel.org>

I actually marked it with:

   Cc: stable@kernel.org

I hope that's the same. Anyway, when I send via quilt mail, it picks up
all the Cc's and sends it out. Which is how I found this.

-- Steve


