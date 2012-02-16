Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2BPQal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:30:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab2BPQak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:30:40 -0500
Date: Thu, 16 Feb 2012 11:30:31 -0500
From: Dave Jones <davej@redhat.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, esandeen@redhat.com
Subject: Re: Corrupted files after suspend to disk
Message-ID: <20120216163030.GA32651@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-pm@lists.linux-foundation.org, esandeen@redhat.com
References: <AANLkTinRC1hXvaXDVV5pOA4YyCdXwAjziZsDzm=LuHqK@mail.gmail.com>
 <AANLkTinewk=mJZifVxEJkCtKfNauOjHnLAqwbGn139C=@mail.gmail.com>
 <AANLkTikui_HQ5JMcMJUqMr9WLyTRNzF-z4G7wAUNPOFy@mail.gmail.com>
 <201103242330.14416.rjw@sisk.pl>
 <CAFLxGvzzHDRma_Y_XEpOD+fY+vonbkoR1mvQp4Vb4c3M6fTsPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzzHDRma_Y_XEpOD+fY+vonbkoR1mvQp4Vb4c3M6fTsPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 11:52:27AM +0100, richard -rw- weinberger wrote:
 
 > >> >> Of course, please test the above separately. :-)
 > >> >
 > >> > Ok, I'll test this when I'm at home.
 > >> >
 > >> > BTW: dropping the caches helps, when some files seem corrupted.
 > >> > Today /usr/bin/okular was broken.
 > >> > After setting vm.drop_caches=1 it worked again.
 > >>
 > >> On Linux 2.6.38 I'm unable to reproduce the issue.
 > >> Only 2.6.37 seems to be affected.
 > >> So, I'm moving over to 2.6.38. :)
 > >
 > Bad news:
 > I saw the issue on 3.x too but thought it's because my IdeaPad s10 is crap.
 > Now with my shiny new Lenovo x121e I have the same issue! :-(
 > 
 > OpenSUSE 12.1, kernel 3.2.7.
 > After a few suspend2disk iterations random files are corrupted.
 > But only cached files. A reboot solves the problem.
 
FWIW, we've been seeing a number of hard to diagnose failures
with suspend to disk for the last few releases in Fedora.
Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
for a while, but there's no smoking gun that really explains what's
getting into these states. Further complicating things, is that it
doesn't seem to be 100% reproducable.

	Dave

