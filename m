Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0GKRW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 13:22:57 -0400
Received: from 1wt.eu ([62.212.114.60]:39183 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0GKRWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 13:22:55 -0400
Date: Sun, 11 Jul 2010 19:22:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100711172252.GA3379@1wt.eu>
References: <201007110918.42120.Martin@lichtvoll.de> <AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com> <201007111651.42963.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007111651.42963.Martin@lichtvoll.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Sun, Jul 11, 2010 at 04:51:42PM +0200, Martin Steigerwald wrote:
> I hope that someone answers who actually can take some critique. From the 
> current replies I perceive a lack of that ability.

well, I'll try to do then :-)

There were some threads in the past about kernel releases quality,
where Linus explained why it could not be completely black or white.

Among the things he explained, I remember that one of primary concern
was the inability to slow down development. I mean, if he waits 2 more
weeks for things to stabilize, then there will be two more weeks of
crap^H^H^H^Hdevelopment merged in next merge window, so in fact this
will just shift dates and not quality.

There are also some regressions that get merged with every pre-release.
Thus, assuming he would wait for one more pre-release to merge the
fixes you spotted, 2 or 3 more would appear, so there's a point where
it must be decided when to release.

Right now it's released when he feels it "good enough". This can be
very subjective, but I'd think that "good enough" basically means
that the kernel will be able to live in its stable branch without
major changes and without reverting features.

Also, you have to consider that there are several types of users.
Some of them are developers who will run a latest -git kernel at
some point. Some of them will be enthousiasts waiting for a feature,
and who will run every -rc kernel once the feature is merged, to
ensure it does not break before the release. There are also janitors
and the curious ones who'll basically run a few of the last -rc as
time permits to see if they can spot a few last-minute issues before
the release. There are the brave ones who systematically download
the dot-0 release once Linus announces it and will proudly run it
to show their friends who it's better than the last one. There are
those who need a bit of stability (eg: professional laptop or home
server) and will prefer to wait for a few stable releases to ensure
they won't waste their time on a big stupid issue that all other ones
above will have immediately spotted for them. And there are the ones
who run production servers who will either use distro kernels of
long term stable kernels, with a more or less long qualification
process between upgrades.

It's just an ecosystem where you have to find your place. From your
description, I think you're before the last ones above, you need
something which works, eventhough it's not critical, so you could
very well wait for 2-3 stable updates before upgrading (that does
not prevent you from testing earlier on other systems if you want
to test performance, new features, regressions, etc...).

It's not really advisable to call dot-0 releases "unstable" because
it will only result in shifting the adoption point between the user
classes above. We need to have enthousiasts who proudly say "hey
look, dot-0 and it's already rock solid". We've all seen some of them
and they're the ones who help reporting issues that get fixed in the
next stable release.

I think that the most reasonable thing to do is to assume your need
for stability and always refrain from running on the latest release.

Speaking for myself, I tend to run rock solid kernels for my data (my
file server was still on 2.4.37.9 till this afternoon, I just upgraded
it to 2.6). The distro's kernel currently is 2.6.33.4 and I'm going to
switch it back to 2.6.32.x or 2.6.27.x because I'd rather have something
fully tested there. My desktop which regularly reaches 50-100 days
uptime runs on whatever looks stable enough for the job when I upgrade.
Usually it's one of Greg's long term stable series. 2.6.27.x or
2.6.32.x, with x >= 10. My work laptop is on similar kernels. My
netbook is generally running experimental code, it does not matter
much. It's where I'd try 2.6.35-rc for instance, or where I test
2.6.32.x-rc when Greg announces them.

You see, there's a kernel for everyone, and for every usage. You just
have to make your choice. And when you don't know or don't want to
guess, stick to the distro's kernel.

Regards,
Willy

