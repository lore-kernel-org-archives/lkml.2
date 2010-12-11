Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0LKC07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 21:26:59 -0500
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:32794 "HELO
	web31806.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752243Ab0LKC06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 21:26:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=J3mlK7alrQSBmSnLxnVgSJPoSgGuogJJtQYp4DGbkWWKhISIkgzOAz/z+Xfc+63p907QsdaNThdmmdcI6qUvSuAtgOWUJkrUxFg6XIV+j63isFoWzpUS3ePsUrX3KlTpM3EaBnsJXbSnnSC/IrmFTBvP5AhRhXzJbNfeIave2cg=;
Message-ID: <760467.30498.qm@web31806.mail.mud.yahoo.com>
X-YMail-OSG: 9ZtEHdcVM1lmaWG_wgSTOJ1VRbc7z835szI_.EUH_JMVlo3
 uln_6mCc3CKUea2U3YhcSDz7lzEZygUs8oZu69jm07BfjvRQgNVVFWlT2iI2
 5BnAvclQCb0w9z2bWcHXpSWMkJbra3gwoOL6uNhmliaF2JGhH.rNmXIUgWvL
 Q6bLkFJxzFE7Qwg8m5IQyCNYefg0.xS3QPAXiT09dnfHKw1D89cRasHLqDJu
 r6GtNQ6h2fU_IZBLYBLOcbVSNV7.0GonBTkBSPfC7wv.a22yJgQKCwm8omtg
 2_nafcpZ1mm5fRu2qbiydnIHabLaE1bRnjK1gehp_FuU5_DpP4XghA0.Ix2S
 gPlzxGLINII2DKBi_C9G54_.Jd7ecddEwBa_2kV.2xljII8LbeJnNg9KaMPr
 fh6zEAMLPKuE0
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Fri, 10 Dec 2010 18:26:56 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <20101210234253.28c5e76e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, don't you work for the same company as do the authors listed in "uas.c"?

--- On Fri, 12/10/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> I think they will judge themselves from the full
> discussion. I'm not sure
> they'll vote in your favour however.

Alan, you're priming up here what people should think.

> "So to expose the obvious, hypothetically, one of the
> resident "linux
> kernel engineers/maintainers" could've submitted AN EMPTY
> DRIVER that
> "binds to" the UAS id, and from then on, any other
> improvements would
> have to go through them"
> 
> Strangely that doesn't work because the community isn't
> full of idiots,

I didn't say it is.

> in fact we actively select against them because anyone who
> is maintaining
> a driver needs to be able to deal with other people (at
> least other
> people who wish to be constructive).

Did you not see the problems Greg has had with Matthew, your co-worker, and stating so? Let me refresh your memory:
http://marc.info/?l=linux-kernel&m=129133499814639&w=2

> "Do you not see HOW DIFFERENT the two drivers are? Do you
> not see the
> difference in quality, presentation, etc, etc."
> 
> I find the presentation *very* different. I'm rather
> worried about the
> manner in which it is being presented.

Wait a minute... So a commit patch is not enough any more? Code is not enough anymore? Quick and knowledgeable responses are not enough anymore?

What was the "uas.c" presentation? ("uas.c" is written by a co-employee of yours.) Can you point me to it?

But you make a very good point: "presentation" is all there is to anything.  If you've got the right presentation you can convince people of *anything*, literally anything.

For example, your response to which I'm replying is one such "presentation".

> Your driver may be
> the best on the
> planet

Well, I don't know Alan? Is it? You can read code, right. No ONE has commented on the code, on technical matter at all. Instead Greg snipped it all out.

> - who knows - but if your response to needing to
> work with people
> is to accuse them of being part of some giant conspiracy or
> make offensive
> comments

Wait a minute here... Is it about code and functionality then? Because if it is I didn't see any technical comments on the drivers.

> then that's rapidly going to outweight the quality
> of the code
> and you'll simply run out of people to talk to.

Here you're involving intangible things, but i realize it's part of your presentation.

> It's actually pretty hard to get in GregKH's kill file, and

It's just a move on his part to show he doesn't want deal with this anymore. Clearly he's expressed an opinion of having hard time working with uas.c's author, co-employee of yours. Clearly he's shown he doesn't want to comment on the technical matters, code, etc, despite all this he's shown to protect defunct code, written by a co-employee of yours, with comments in it like this:

> /* I hate forward declarations, but I actually have a loop */
and:
> /*
> * Why should I request the Status IU before sending the Command IU?  Spec
> * says to, but also says the device may receive them in any order.  Seems
> * daft to me.
> */

Anyway, I've noted these and other technical matter in the 18 major differences between the two drivers here:
http://marc.info/?l=linux-usb&m=129185378612218&w=2

> I suspect by
> now you are in a few others as well. So perhaps you can

You are telling people here what they should think and do.

> find someone
> working with you who has people skills and can sit between
> you and Greg
> and other maintainers and make progress ?

There is no agenda for Linux and there has never been. My submission was purely to help others and give them something useful they can use to test and develop their UAS devices, an alternative to Windows. It took me two days to write this driver. I decided to help people because I could. There never has been an agenda to have a UAS driver (let alone mine) in Linux.  But it was interesting to see the dynamics involved.  

> It won't be the
> first time a
> user interface problem has been fixed that way in the Linux
> world.

Or the last. Linux is open source but closed community.

> But basically it's really simple. When we have an existing
> driver we work
> from it - step by step from where we are, to where we want
> to be.

The existing driver shows lack of knowledge of UAS and SCSI. It falls short of almost everything. For the details see the 18 points here:
http://marc.info/?l=linux-usb&m=129185378612218&w=2

Why would you want to keep this in the kernel and "start from it", when we can rip it out, put the working and correct uasp.c in and then everyone including Matthew can contribute to uasp.c. It doesn't seem he works with the technology as I haven't seen any new patches to uas.c.

It's quick and constructive process. Out with the defunct and and in with what works. It's all about getting things done.

> That
> series of steps should tell a story so anyone reading the
> patch series can
> understand how it unfolded.

But there would be NOTHING LEFT of the original driver. Just one patch like this I posted here to uas.c changed 86% of the code. A diff between uasp.c and uas.c shows 100% difference.

> We also have a process for dealing with people not
> responding, and

"Not responding" -- are you talking about your co-worker?

> irritating them enough they killfile you and refuse to deal
> with you
> isn't that process, especially when you then get yourself
> killfiled by
> the next maintainer up as well.
> 
> When you come along late and say "I've got this great other
> driver", then
> sorry you missed the party - you could have submitted yours
> earlier and
> the question becomes "how do I make the existing driver at
> least as cool
> as the one that was too late" not "how do I replace it"

Alan, none of this is really important. As technologist, I thought it would be helpful and useful to write a functional UAS driver. Since the one in the kernel, was defunct, judging from how it behaved, how it locked up, how it went into an infinite loop, and the comments there-in.  I did submit patches to uas.c, which got secretly modified, both the commit message and the patch, but never posted publicly as to what was modified. Even Greg commented on this not-so-good practice (see link above).

The uasp.c took two days to write.

But here is what I would've done had someone, especially a technologist, posted a working driver while mine didn't do the job: I would not have been quiet about it but simply asked to include the better working driver and I'd contributed whatever I could to it.  It's a quick, practical and constructive thing to do. It's what gets things done. In the long run though "uas.c" would look exactly like "uasp.c" looks today. There is just so few ways to do the same thing.

However this isn't the first time this will happen or the last. rlt8139.c and 8139too.c come to mind, although the former had been around for a long time and there were plenty of devices out there for it. There maybe other instances like this.

    Luben

