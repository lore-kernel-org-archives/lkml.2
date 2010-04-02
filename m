Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0DBREk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:04:40 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:48141 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab0DBREe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:04:34 -0400
Date: Fri, 2 Apr 2010 19:59:35 +0300
From: Ozgur Yuksel <ozgur.yuksel@oracle.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel
 paging request - comm: pccardd
Message-ID: <20100402165935.GA3238@oracle.com>
References: <bug-15621-10286@https.bugzilla.kernel.org/>
 <201003301711.00351.bjorn.helgaas@hp.com>
 <20100401091808.GA3236@oracle.com>
 <201004011134.15175.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011134.15175.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB622CE.00C1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, Apr 01, 2010 at 11:34:13AM -0600 was the time for Bjorn Helgaas to speak thus:
> Using ignore_loglevel shouldn't affect the problem, so I'm confused.
> Can you reproduce the original problem and attach the entire serial
> console log?

It seems that the problem does not reproduce at all now. Unfortunately I do not
have the images I have built on 2010-03-29 08:46 and building from a fresh
ae6be51ed01d6c4aaf249a207b4434bc7785853b does not reproduce the problem. It is
most likely the specific .config I used at the time (which I do not have
anymore). Also I have been doing other builds on the same system, so maybe it
was just a stale module or smth. 

FWIW the problem does not reproduce with 2.6.34-rc3 at all too (on the very same
hardware).
