Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0H3T2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:28:24 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:58264 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753088Ab0H3T2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:28:23 -0400
Message-ID: <4C7C0651.6070109@example.com>
Date: Mon, 30 Aug 2010 21:28:17 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36-rc3
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
In-Reply-To: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 455707989427319098
X-Ovh-Remote: 83.24.108.206 (doa206.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.2010 19:25, Linus Torvalds wrote:
> You all know the drill by now: another week, another -rc.
>
> Nothing in particular stands out that I can recall. As usual, it's
> mostly driver updates (65%), of which a large piece (by line count) is
> just the removal of a staging driver that isn't really ready nor
> making any progress. But on the "somewhat more likely to cause
> excitement" front, there's some radeon/nouveau drm updates too.
>
> Outside of drivers, you have CIFS, ceph and xfs filesystem updates,
> and sparc/blackfin on the arch side. And various random noise -
> networking, fsnotify, an anonvma locking fix etc. The appended
> shortlog gives a fairly good idea of what kinds of things have been
> going on.
>
> Anyway, I'm hoping it is going to be an extremely boring -rc, because
> I'm just about to leave for LinuxCon Brazil, and while I'll follow
> issues over email, I'm not planning to do any pulls for the next week.

Will someone tak care of frequent git updates for kernel?

Regards,

Piotr Hosowicz

-- 
Janusz Korwin-Mikke:
"Idiota z dyplomem to taki sam idiota,
jak przedtem - tylko z pretensjami."
NP: Ozzy Osbourne - Mr Tinkertrain
NB: 2.6.36-rc3-20100830-1743+
