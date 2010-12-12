Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0LLENr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 23:13:47 -0500
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:43556 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750854Ab0LLENq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 23:13:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=usiBsLmvU1wHOoxp3TQx7YhKx8M4KKGth/HE1WlyoZI8DfPAmLjLyVaGTPvZv8KnwGqmgYr4A4l/IZUy/I9F9/5SUjkciw/XzsZvigAlS0On8hGzTcrLQymJRRz7RbpEXxCRw86CiuYGtZxckLDBujrf4MegIm6Slrgap/o8TZg=;
Message-ID: <266179.95268.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: YrUM110VM1kMWR6f170CM01v1aOP_qEycdV2xPK_Q3gSoN3
 5YZcfVK88Gy8s2jgkkuI2YTI8SiyGYH4FsbXBa8URtaiHqz_x5veDBO48spX
 6Rb90_Zjj6BoDqNnSeoTmfO_yLA2XsxKIwE0sE7LoP2V0VxU2cQYqZ3iWXVT
 lAvDOflZjicEubxWgx3x84Z2oDkj2rbxxpESxHmSIaNCG_W6krgfZY6DAW5a
 .y.878TcLVhZXDHYj.MyVDAYs7lf4JuAQk6x4MgOBY32vpU24Bnjt2E6yE4J
 GHKqoKNW007LFpZbsE_boM9t.jeohPUDBzBczaG03Fs0w4doF3Z7FUHs5pyz
 0efQu8hbBoFLwpny5c2mLgFYuJFeHQA4S1VvoR.bVQde6taJREWaFH..RW6O
 RJUIhWuhA8FI-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Sat, 11 Dec 2010 20:13:44 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] memstick: add support for legacy memorysticks
To: Maxim Levitsky <maximlevitsky@gmail.com>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Aries Lee <arieslee@jmicron.com>
In-Reply-To: <s5hsjy4bqxi.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sat, 11/12/10, Takashi Iwai <tiwai@suse.de> wrote:

> 
> > Takashi, you are welcome to look at my version of
> code, the one that
> > Alex mostly refuses to merge.
> > It is located at http://gitorious.org/ricoh-kernel/ricoh-kernel
> > (This contains everything I did for ricoh and
> jmicron)
> > Try this code and see if MS standard works for you in
> parallel mode.
> > 
> > If it doesn't, every module contains built-in
> debugging, activated by
> > debug=1 or 2 module parameter, yet another thing Alex
> refused to
> > consider.

This should be done through a common kernel infrastructure.
It was added there for a reason.

> 
> It's an unfortunate situation.  I see the point Alex
> mentioned (small
> changes first), but honestly, I don't understand why this
> kind of
> patches has to be blocked, too.  It's basically an
> addition for the
> support of missing device types.
> 

I never said I have any opposition to supporting other device types.
My proposal was, from the very beginning, to merge new drivers first,
than discuss changes to the existing stuff.



      
