Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2LVC5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:57:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LVC5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:57:30 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=D19gQVrFAAAA:8 a=Zk9d7ZSQ55XISnjjRG8A:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 21 Dec 2012 21:57:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Linux 3.8-rc1
Message-ID: <20121222025722.GA27621@home.goodmis.org>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:00:58PM -0800, Linus Torvalds wrote:
> The longest night of the year is upon us (*), and what better thing to
> do than get yourself some nice mulled wine, sit back, relax, and play
> with the most recent rc kernel?
> 
> This has been a big merge window: we've got more commits than any
> other kernel in the v3.x kernel series (although v3.2-rc1 was *almost*
> as big). It's been a rather busy merge window, in other words.
> 
> The diffstat looks normal: about 63% of the patch being to drivers
> (staging, networking, scsi, gpu, sound, drbd etc) , 18% architecture
> updates (with various ARM platform things being the bulk of it as
> usual, sigh), and the rest being "various", like core networking,
> filesystems (new f2fs flash-optimized filesystem) and include files
> etc.
> 
> I'm appending the "merge shortlog" which is about the only half-way
> readable automated data I can give you. There's a *ton* of stuff here.
> Go out and test it,

Hi Linus,

Was there anything wrong with Frederic's printk patches? They are needed
as one of the steps to acheive tickless for a CPU running a single task.

 https://lkml.org/lkml/2012/12/17/177

Maybe his "RFC" threw you for a loop. It was RFC as, if you're OK with
it, please pull it, otherwise please comment to what you think is
wrong with it.

It's been in linux-next for a while without anyone complaining about it.
I replied to his patch with the diff against your tree as Frederic left
that out.

Thanks,

-- Steve

