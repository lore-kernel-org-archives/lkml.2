Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2ACSAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:00:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab2ACSAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:00:32 -0500
Date: Tue, 3 Jan 2012 13:00:21 -0500
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Dell Studio 1536 needs pci=nocrs to boot.
Message-ID: <20120103180020.GA15014@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20111230193704.GA2874@redhat.com>
 <20120101145354.GA1791@elte.hu>
 <20120103093020.0cbcd735@jbarnes-desktop>
 <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 10:55:00AM -0700, Bjorn Helgaas wrote:
 > On Tue, Jan 3, 2012 at 10:30 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
 > > On Sun, 1 Jan 2012 15:53:54 +0100
 > > Ingo Molnar <mingo@elte.hu> wrote:
 > >
 > >>
 > >> * Dave Jones <davej@redhat.com> wrote:
 > >>
 > >> > Some machines don't boot unless passed pci=nocrs.
 > >> > (See https://bugzilla.redhat.com/show_bug.cgi?id=770308 for details of
 > >> >   one report. Waiting on dmidecode output for others).
 > >> >
 > >> > Currently there is a DMI whitelist, even though the default is on.
 > >> >
 > >> > This patch extends that dmi list to add a blacklist to automatically
 > >> > apply disable it when necessary.
 > >> >
 > >> > Signed-off-by: Dave Jones <davej@redhat.com>
 > >>
 > >> Acked-by: Ingo Molnar <mingo@elte.hu>
 > >>
 > >> Jesse, will you take this one?
 > >
 > > Yeah, I can take it.  Bjorn, any comment (I'll bounce over the
 > > original)?
 > 
 > This is a band-aid, and we'll have to extend the blacklist for other
 > machines, but it's the best we have right now, so I think it's the
 > right thing to do.
 > 
 > It's probably the same as
 > https://bugzilla.kernel.org/show_bug.cgi?id=31602 (Dell 1546) and
 > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/647043

There's at least one more dell (Seems that entire 'studio' product line
is affected) that I'm waiting on DMI data from.
Also a thinkpad that I have a patch pending for.

	Dave

