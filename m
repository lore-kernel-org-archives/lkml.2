Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0J0Oij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:38:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0J0Oii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:38:38 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=ZDzuQiiN56AA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=SyI_GHdlAAAA:8 a=WPyIoOwQAAAA:8 a=tsvOLuEiFaFAFILXScQA:9 a=VTmaPT9_Z_SN8OkkgzWWlG6jX1sA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=UQxMgyrMzRwA:10 a=1DbiqZag68YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3] ftrace/MIPS: Add MIPS64 support for C version of
 recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, John Reiser <jreiser@bitwagon.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
In-Reply-To: <AANLkTinsfveuYdo4YJGHqasPgG=+ftL-8sbC5_aYAytt@mail.gmail.com>
References: <cover.1288176026.git.wuzhangjin@gmail.com>
	 <910dc2d5ae1ed042df4f96815fe4a433078d1c2a.1288176026.git.wuzhangjin@gmail.com>
	 <1288186366.18238.125.camel@gandalf.stny.rr.com>
	 <AANLkTinsfveuYdo4YJGHqasPgG=+ftL-8sbC5_aYAytt@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 10:38:35 -0400
Message-ID: <1288190315.18238.128.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 22:09 +0800, wu zhangjin wrote:
> On Wed, Oct 27, 2010 at 9:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed, 2010-10-27 at 18:59 +0800, Wu Zhangjin wrote:
> >> From: Wu Zhangjin <wuzhangjin@gmail.com>
> >
> > The From above states that you wrote this. Did you modify what John and
> > Maciej did? If so, please state clearly what each author has done, and
> > how you modified it. If you did not write this, please change the From
> > to the correct author.
> >
> > If you did modify it, then state something like this in the change log.
> >
> > Original version written by John Reiser <jreiser@BitWagon.com>
> >
> > Usage of "union mips_r_info" and the functions MIPS64_r_sym() and
> > MIPS64_r_info() written by Maciej W. Rozycki <macro@linux-mips.org>
> >
> 
> yeah, that is true above.
> 
> > Then state the changes you made.
> 
> I didn't change it, just added the comments in the patch log and tested it.
> 
> Should I resend the patch with the change log information about John and Maciej?
> 

I can make the changes.

Then the patch is originally John's, right?

I'll make him the author, with the comment about Maciej, and keep you as
the Tested-by.

-- Steve


