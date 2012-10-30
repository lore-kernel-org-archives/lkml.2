Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab2J3WXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:23:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2J3WXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:23:14 -0400
Message-ID: <5090532D.4050902@vlnb.net>
Date: Tue, 30 Oct 2012 18:22:37 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org>
In-Reply-To: <20121027044456.GA2764@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:0/nqC7UcgqjR15tTt1WhCFMt1XThWPmS7lfcRlHJ14U
 58h1BSkOVozuX8u8g8SU7kK5ed/LXFC+1hUfJ6hK3sHDmr6ZMD
 iauw8Cdw8n+Ike+ubBJ23yuseVhHrDXlvejr7ceAot6ya4QqKC
 mqao33j7gXbrB3TPRoxta2Bt/Lx/6B4ZByXFmAOrKmzIFuoP4r
 KDEewD6tLnouwyQRavhKfD6Qs610gPYrts59Ralau786iR0u8r
 gjlQ1EWnK05k9wkqiLSKjk4YfPOSFOl4hUynVyZhxKYbv92DDv
 GYKfze8Y0CrmBwoTLr81EfxD1ZiKvLpcENssmFuwishjEWAf5I
 X41sNT8ynLHnClMlxeWQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Theodore Ts'o, on 10/27/2012 12:44 AM wrote:
> On Fri, Oct 26, 2012 at 09:54:53PM -0400, Vladislav Bolkhovitin wrote:
>> What different in our positions is that you are considering storage
>> as something you can connect to your desktop, while in my view
>> storage is something, which stores data and serves them the best
>> possible way with the best performance.
>
> I don't get paid to make Linux storage work well for gold-plated
> storage, and as far as I know, none of the purveyors of said gold
> plated software systems are currently employing Linux file system
> developers to make Linux file systems work well on said gold-plated
> hardware.

I don't want to flame on this topic, but you are not right here. As far as I can 
see, a big chunk of Linux storage and file system developers are/were employed by 
the "gold-plated storage" manufacturers, starting from FusionIO, SGI and Oracle.

You know, RedHat from recent times also stepped to this market, at least I saw 
their advertisement on SDC 2012. So, you can add here all RedHat employees.

> As for what I might do on my own time, for fun, I can't afford said
> gold-plated hardware, and personally I get a lot more satisfaction if
> I know there will be a large number of people who benefit from my work
> (it was really cool when I found out that millions and millions of
> Android devices were going to be using ext4 :-), as opposed to a very
> small number of people who have paid $$$ to storage vendors who don't
> feel it's worthwhile to pay core Linux file system developers to
> leverage their hardware.  Earlier, you were bemoaning why Linux file
> system developers weren't paying attention to using said fancy SCSI
> features.  Perhaps now you'll understand better it's not happening?
>
>> Price doesn't matter here, because it's completely different topic.
>
> It matters if you think I'm going to do it on my own time, out of my
> own budget.  And if you think my employer is going to choose to use
> said hardware, price definitely matters.  I consider engineering to be
> the art of making tradeoffs, and price is absolutely one of the things
> that we need to trade off against other goals.
>
> It's rare that you get to design something where performance matters
> above all else.  Maybe it's that way if you're paid by folks whose job
> it is to destablize the world's financial markets by pushing the holes
> into the right half plane (i.e., high frequency trading :-).  But for
> the rest of the world, price absolutely matters.

I fully understand your position. But "affordable" and "useful" are completely 
orthogonal things. The "high end" features are very useful, if you want to get 
high performance. Then ones, who can afford them, will use them, which might be 
your favorite bank, for instance, hence they will be indirectly working for you.

Of course, you don't have to work on those features, especially for free, but you 
similarly don't have then to call them useless only because they are not 
affordable to be put in a desktop [1].

Our discussion started not from "value-for-money", but from a constant demand to 
perform ordered commands without full queue draining, which is ignored by the 
Linux storage developers for YEARS as not useful, right?

Vlad

[1] If you or somebody else want to put something supporting all necessary 
features to perform ORDERED commands, including ACA, in a desktop, you can look at 
modern SAS SSDs. I can't call price for those devices "high-end".


