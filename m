Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab1C3RvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:51:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50736 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1C3RvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:51:17 -0400
Date: Wed, 30 Mar 2011 19:51:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Message-ID: <20110330175106.GB1601@aftab>
References: <cover.1300996141.git.mchehab@redhat.com>
 <20110324173257.36680b90@pedra>
 <20110324223907.GA10498@liondog.tnic>
 <4D8C6C80.8010600@redhat.com>
 <20110325141322.GB28313@gere.osrc.amd.com>
 <4D8D078C.1040201@redhat.com>
 <20110328170302.GF11590@aftab>
 <4D90E525.4030709@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301A7A60074@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301A7A60074@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 01:27:43PM -0400, Luck, Tony wrote:
> > A INT13 persistent data saving will probably be too hard to implement for
> > all kind of storages. So, it will probably need lots of hack in order to
> > work. Also, some hardware may even not have any local hard disk. Not sure
> > if it is worth to spend time on it.
> 
> Linus was pretty clear that he didn't like the idea when
> it came up a few weeks ago in the:
>  [PATCH 0/2][conce​pt RFC] x86: BIOS-save kernel log to disk upon panic
> thread.
> 
> Linus ranted:
> > Quite frankly, I'm not likely to _ever_ merge anything like this.
> >
> > Over the years, many people have tried to write things to disk on
> > oops. I refuse to take it. No way in hell do I want the situation of
> > "the system is screwed, so let's overwrite the disk" to be something
> > the kernel I release might do. It's crazy. That disk is a lot more
> > important than the kernel, and overwriting it when we might have
> > serious memory corruption issues or something is not a thing I feel is
> > appropriate.
> 
> I agree with him - writing to disk from a known broken kernel (using
> a probably buggy BIOS) is a disaster waiting to happen to somebody's
> disk.

I can't say I don't agree. The reference to the BIOS method was simply
to say that we need some kind of a solution for saving OOPSen and other
error info on clients too, with no pers. storage hw. And frankly, and
AFAICT, we don't have one that would work reliably on existing hw right
now :(.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
