Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1EWQWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:22:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1EWQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:22:11 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=73qD3fekirQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IJv9LcIfAAAA:8 a=yrH4GF8zMui5lNqqEk0A:9 a=PUjeQqilurYA:10 a=K6kUPx8HyhEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch v2] checkpatch: Signature format verification
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: anish singh <anish198519851985@gmail.com>, davej@redhat.com,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306124078.1681.10.camel@Joe-Laptop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306073772.1681.6.camel@Joe-Laptop>
	 <BANLkTimMPvn87E0EEqT4vhox4_8nQ4pMug@mail.gmail.com>
	 <1306124078.1681.10.camel@Joe-Laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 23 May 2011 12:22:09 -0400
Message-ID: <1306167729.1465.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 21:14 -0700, Joe Perches wrote:
> On Mon, 2011-05-23 at 08:26 +0530, anish singh wrote:
> > On Sun, May 22, 2011 at 7:46 PM, Joe Perches <joe@perches.com> wrote:
> >         On Sun, 2011-05-22 at 15:48 +0530, anish wrote:
> >         > This patch generates warning when there is no space between
> >         > the patch submitter and successive mail-id.
> >         []
> > What does this mean?I checked in kernelnewbies archives and asked
> > on IRC channel but couldn't get the meaning.Kindly let me know.
> 
> It means I didn't quote all of your original message.
> 

Of course, we usually do "[...]" or "[..]". Without the dots, it just
looks like some kind of uninitialized array.

-- Steve


