Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0ITWiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:38:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0ITWiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:38:13 -0400
X-Authority-Analysis: v=1.1 cv=Ba7GFA6IM/Rlu/bGJ5lftWmk/oljGo5ZwASPcBcXAAo= c=1 sm=0 a=efo-eZkTzUcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=P5wrnlEIAAAA:8 a=nTzIIlD1-3tuQacf-JEA:9 a=oE4bRwlgjrWX6MUKV4UGmPvmrGIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=nXjPMxIiGpsA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 09/10] jump label 11: add sparc64 support
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
In-Reply-To: <20100920.153023.226756815.davem@davemloft.net>
References: <cover.1284733808.git.jbaron@redhat.com>
	 <3b5b071fcdb2afb7f67cacecfa78b14c740278a7.1284733808.git.jbaron@redhat.com>
	 <1285021546.23122.698.camel@gandalf.stny.rr.com>
	 <20100920.153023.226756815.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Sep 2010 18:38:11 -0400
Message-ID: <1285022291.23122.728.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 15:30 -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 20 Sep 2010 18:25:46 -0400
> 
> > 
> > Jason, did you author this patch or did David?
> 
> I did.
> 
> Jason when you post patches other people have authored, you should
> add a:
> 
> From: Mr. Author <email_of_author@foo.com>
> 
> to the top of your commit message.
> 
> This allows automated tools that pull patches into GIT to set
> the author correctly when it is not you.
> 
> Thanks.

Thanks, I figured you did when I saw your SoB. I'll add your From line
manually, when I pull it.

-- Steve


