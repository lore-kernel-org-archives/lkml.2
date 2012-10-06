Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2JFSCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:02:20 -0400
Received: from smtp.getmail.no ([84.208.15.66]:53985 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2JFSCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:02:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: el_es <el.es.cr@gmail.com>
Subject: Re: Minimal jitter = good desktop.
References: <op.wlqe9kw36426ze@localhost.localdomain>
 <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm>
 <op.wlrdzkqh6426ze@localhost.localdomain>
 <loom.20121006T164640-362@post.gmane.org>
Date: Sat, 06 Oct 2012 20:02:16 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlrq12q96426ze@localhost.localdomain>
In-reply-to: <loom.20121006T164640-362@post.gmane.org>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is really simple, and I don`t care about top posting, down posting,  
in the middle comments or whatever. Do whatehver you like, and have no  
other rule that what is in your soul. That is what drives ultimately  
society. Look up Aristotle natural-law. Which actually is based in divine  
nature.

Now jitter, is really easy. Jitter-sensitive OpenGL applications will show  
visible jitter. Doom 3 is extremely sensitive. I have tried to make it run  
well many times, but it wasn`t until I became aware of more unintuitive  
behaviour not according to theory with some settings, and I started trying  
reversing them. And then I found 90hz to be optimal, and giving a  
perfectly running doom 3. Someone actually suggested I try 10000hz BFS  
patch, because "it would reduce latency." Which I did. But then I also  
tried 20hz, and there was little difference on BFS. Ultimately I arrived  
at 90hz with CFS, and tweaking it`s granularity a bit, and it worked well.  
(Better than BFS). So in that case, JITTER is solved. Also a lot of  
low-jitter configs use low hz. So that seems to back it up. And everything  
on my computer seems to be running better. Smoother, more responsive. Even  
the ads in my browser ;(

I also appreciate those who can measure small jitter in the uS range, and  
mitigate it. But I would also like for those, to check if a simple  
hold-logic would be better. For the 10ms filter I mentioned. Say hold for  
1ms at 0, and then to regular peak values. It seems that would be a better  
filter. This just me being a perfectionist ofcourse.

So yes, according to the general definition of "os-jitter" it seems highly  
reduced.

I don`t know at all why you are mentioning opengl calls. Obviously games,  
do run quite well. Atleast now. It is also going to be great to test new  
games coming, and keep iterating knowledge and tuning. Also ofcourse  
OpenGL is a great part of Wayland, and I hear more h/w is used there, and  
hopefully it doesn`t stop performance in games, so one can have an  
effectful desktop, without worrying about game-performance. Some of the  
GUI in doom3, running completely smooth, shows some great potential for  
GUI-ideas aswell :)

Peace Be With You.

On Sat, 06 Oct 2012 16:53:16 +0200, el_es <el.es.cr@gmail.com> wrote:

> Uwaysi Bin Kareem <uwaysi.bin.kareem <at> paradoxuncreated.com> writes:
>
> [sorry for cutting out the context], but it's been topposted]
>
> But the problem is, we cannot measure 'jitter' directly.
> There is no reliable benchmark that produces results adherent
> to what someones' definition of 'jitter' is.
>
> At software level we only have a notion of latency, and that
> leads to jitter as david said, but as the kernel is not real-time,
> you cannot guarantee every opengl command/fb transfer will be finished
> in time for next frame to be drawn.
>
> Maybe if someone could get the information of % finished frames
> (or % dropped frames) within one slice of userspace, that would
> be something to build on, but it's still a derivative and with
> unknown bias level.
>
> Lukasz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
