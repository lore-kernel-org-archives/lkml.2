Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab2AMXvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:51:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2AMXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:51:51 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0tqiLhzIOFI2S6QjZdEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326498708.7642.128.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: Bernardo Barros <bernardobarros2@gmail.com>
Cc: Tim Sander <tim.sander@hbm.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Date: Fri, 13 Jan 2012 18:51:48 -0500
In-Reply-To: <CAOEEKGXUJC9Mmu7azKSvQNkoB3Z_aLPTCDWABOE5WpHRKR=YNg@mail.gmail.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <1326376484.7642.65.camel@gandalf.stny.rr.com>
	 <201201121757.25467.tim.sander@hbm.com>
	 <201201131042.08323.tim.sander@hbm.com>
	 <CAOEEKGXUJC9Mmu7azKSvQNkoB3Z_aLPTCDWABOE5WpHRKR=YNg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 10:45 -0800, Bernardo Barros wrote:
> Will 3.0-rt continue to receive bugfixes in parallel with 3.2-rt? Will
> it be a LTS kernel as 3.0 is?


Yes, I will still be maintaining it.

But as with mainline stable, there's some rules I follow. I do not add
any patch that is not yet in 3.2-rt (or whatever is the latest rt),
Linux mainline, or Linux stable. A patch must be in one of the above
before I add it.

With the exception if the patch only pertains to fix a bug in 3.0-rt and
that code no longer exists in 3.2-rt.

-- Steve


