Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0LJXPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:15:35 -0500
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:41368 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753945Ab0LJXPd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:15:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=p5NNpVmlwhfO7MzjwURSFlN9J/kKFwGXssRLjxidhBLIXeJJFCgKNI0x2P+5wIumdptZu49p0KhzmpK9lXuq2da49iGsE+kl8+BIucO/AEv/yqGp0biDmuAH3xkaiNkP04gUX/UCCLlV7toxF6yInvR81Mf/8nWyJ+9oxFizeyg=;
Message-ID: <882104.74689.qm@web31813.mail.mud.yahoo.com>
X-YMail-OSG: Q2kz5ycVM1nL9zqzbyL_Sfo0dkYPJuz3xC_.3eM9LkRB3Am
 tuo2Ea2rGI7Tmp.o8Zrv7XhWuxJ7r.fZAnOvTkFqaPtb_NjpiEHlW.aYhQEs
 uUyUrGHuIexXE0rWrZy87vWaFrU7IWqosjw4nmqn.xxf7Hq4sMyFUohhhCwy
 dKYGErnLWp5kNYdicNmY_q0_pG8t56cEAJeVXFo7DhVw.iPM.VVgPGZk8jzH
 OiQX7QcKhopdAXYwiwq09fisGIKoYuGCG5j27CFD2lWYnHAV19VZAwbz8Bro
 49BU8txtsDaADLf4o7JtSkQBzone7SB9kTyrnySpHOo_tLnZEgP5uUVRP1L_
 WcfKM8Krno6tLURMIixA9h9dILETxcMEirxaoXTB73zsA_XOTPtICeFCEIEe
 dSziM1.iFbt6x
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Fri, 10 Dec 2010 15:15:31 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before I begin, I'd like everyone to note that Greg has completely ignored (and removed from the quotation) the 18 points of technical matter in my email and instead decided to write this, to which I'm responding here:

--- On Wed, 12/8/10, Greg KH <greg@kroah.com> wrote:
> 
> What I don't want in _anyones_ kernel is multiple drivers
> wanting to
> attach to the same device.
> 
> By "same thing" I mean "binds to the same device."

Thanks for clarifying, Greg. For a moment everyone thought that by "the exact same thing" you meant "same functionality, same quality, identical, etc".

Now, if you don't want the still-born uas.c to bind to the same device, please simply remove the ids from that driver.

> I have lived through the hell of this in the past and I
> will not let
> that happen again, sorry.

So, according to your statement above "binding to the same device" is all it takes. The solution is very simple--see above.

So to expose the obvious, hypothetically, one of the resident "linux kernel engineers/maintainers" could've submitted AN EMPTY DRIVER that "binds to" the UAS id, and from then on, any other improvements would have to go through them, even if they don't work with the technology and are not very (at all?) knowledgeable about the technologies/standards/methodologies/termninology involved.

> I'm not saying that the in-kernel driver is perfect at all,

I think you did say "the exact same thing" ;-) in your previous email in this thread saying it "*does* the exact same thing".

So I guess, you didn't clarify what you meant by "does" when you said "does the exact same thing". Thanks for clarifying that by "does" you mean "binds to the same ids".

> and it's
> author is getting annoying by refusing to answer my emails,
> but still,
> please work with him to get the in-kernel driver to work up
> to your
> needs.

Why are you pushing him to this when he's getting annoying to you? When he's not responding to your emails? Is he your friend? (perhaps more?--none of my business) Do you guys have beers at LinuxCon or other Linux conferences? Is he in the technology sector? Or is he just a "linux kernel engineer"? A guru in USB? Or maybe SCSI? Is his employer, Intel, pressuring you? Because when you removed all possibilities, however improbable, must be the truth. (after all they did write the XHCI HCD) All I see is a lot of nepotism, an inferior coding, inferior terminology used, inferior naming convention, incompetence in USB and SCSI protocols, etc, etc, etc.

Were you not part of the same thread where YOU RESPONDED addressing its author about his cowardly and lacking-professional-integrity ways of changing my patches including changing the commit messages without reporting what's been changed, how it's been changed and where it's been committed to? To refresh everyone's memory, here:
http://marc.info/?l=linux-usb&m=129133499714636&w=2
I guess you had to do that to be released of some kind of binding?

Do you not see HOW DIFFERENT the two drivers are? Do you not see the difference in quality, presentation, etc, etc.

Linux is truly open source, but closed community. You have shown in this thread that it's not about the code or the technology, but the turf. After I listed the technical differences between the two drivers in this thread (18 and counting), after you've seen the code and leading on with this thread despite the problems you're having with him and his not responding to your emails.  Why you are protecting his interests so blatantly despite the problems you're having with him is beyond me. (other than, again, if his employers is involved and pressuring you)

"...whatever is left, however improbable, must be the truth."

> If you have problems with the maintainer, please let me
> know and I'll
> see what I can do.

What? Were you not on the CC list of the patches I posted, did you not state in those threads you're having problems with him too? You yourself admitted above that you also have problems with him in those very threads. You are protecting a person, not code.
Here are the threads:
http://marc.info/?t=128821112700001&r=1&w=2
http://marc.info/?t=128829652800022&r=1&w=2
http://marc.info/?t=128839891500022&r=1&w=2
http://marc.info/?t=128901886000001&r=1&w=2

> But again, this driver is not acceptable as-is, sorry.

"as-is"? You are giving me a clue, Greg! (Since you're NOT specifying any technical reasons.)

Greg, (to expose the obvious agenda and interests being protected) how about if I added his name as an author to my driver? Will you accept it then? Or perhaps I can send in a patch ripping out everything from the still-born uas.c other than the copyright and MODULE_AUTHOR() and substituting in the contents of my uasp.c (removing my name altogether)?

After all, people and the industry are learning a lot from this thread.  They are learning that the open source Linux kernel has been institutionalized between a few chosen people, regardless of capability, thus creating a closed community whose interests are highly protected. It's not about the code or the technology any more.

I think people need to know.

     Luben


