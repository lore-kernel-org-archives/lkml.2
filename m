Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab0FAUhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:37:37 -0400
Received: from bosmailout08.eigbox.net ([66.96.190.8]:47594 "EHLO
	bosmailout08.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab0FAUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:37:36 -0400
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 16:37:36 EDT
X-EN-OrigOutIP: 10.20.18.2
X-EN-IMPSID: Qk6N1e00S02gpmq01k6N36
Message-ID: <4C05684D.5050204@jaysonking.com>
Date: Tue, 01 Jun 2010 15:06:37 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Greg Freemyer <greg.freemyer@gmail.com>,
       Kay Diederichs <kay.diederichs@uni-konstanz.de>,
       "Jayson R. King" <dev@jaysonking.com>, Stable team <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Dave Chinner <david@fromorbit.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com> <20100530212502.GQ26177@thunk.org> <4C0358B1.1050605@uni-konstanz.de> <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com> <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
In-Reply-To: <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 09:49 AM, Theodore Tso wrote:
> This is one of the things that confuses me, actually.  Why is it that there are a number of people who want to use ext4 on 2.6.27?   Even the enterprise distro's have moved on; SLES 11 SP1 upgraded their users from 2.6.27 to 2.6.32, for example.  I wonder if it's time to start a new "stable anchor point" around 2.6.32, given that Ubuntu's latest Long-Term Stable (Lucid LTS) is based on 2.6.32, as is SLES 11 SP1.  The RHEL 6 beta is also based on 2.6.32.  (And I just spent quite a bit of time over the past week backporting a lot of ext4 bug fixes to 2.6.32.y :-)
>
> If there are people who want to work on trying to backport more ext4 fixes to 2.6.27, they're of course free to do so.  I am really curious  as to *why*, though.

2.6.27 is still a good kernel and ext4 is a good filesystem, IMO 
(existing deadlock notwithstanding).

Like Kay Diederichs mentioned, .27 has received ext4 updates in the 
past, even as recently as April this year ("ext4: Avoid null pointer 
dereference..."). Though this of course does not imply that .27 should 
receive ext4 fixes (or other fixes) forever, but it is nice to fix the 
most serious, show-stopping problems if it is feasable.

(maybe OT?: When I made an attempt to switch to kernel .31 or .32 
earlier, the kernel would not boot for me. Surely, I can do some 
investigating and get it to boot some day, but I wasn't motivated to 
solve it at the time and stuck with .27 instead.)

Thanks for the comments.

Rgds,

Jayson

