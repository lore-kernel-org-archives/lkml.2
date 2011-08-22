Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1HVAxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:53:00 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:52108 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1HVAw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:52:58 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
In-Reply-To: <20110819121308.GA16386@thinkpad-t410>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <20110818173959.GE28313@thinkpad-t410> <87hb5ddcsa.fsf@emc.com.tw> <20110819121308.GA16386@thinkpad-t410>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 22 Aug 2011 08:55:16 +0800
Message-ID: <87y5ymmfij.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Fri, 19 Aug 2011 07:13:08 -0500, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Fri, Aug 19, 2011 at 04:29:57PM +0800, JJ Ding wrote:
> > > You should only report the ABS_[XY] coordinates when fingers != 0. The
> > > xorg synaptics module sees the values reported in that case as
> > > legitimate. This is causing me to see strange behaviors when scrolling
> > > with two-finger drags.
> > AFAIK, though v2 and v3 differ in packet format, they really report the
> > same data to the userspace. In this version of v3 support, I even try to
> > make v2 and v3 report all the data in the same sequnce. If you're seeing
> > this issue, maybe we should do the same with v2?
> 
> Actually neither v1 nor v2 reports ABS_[XY] unless fingers != 0. In v2
> the reporting is in a switch statement on the number of fingers, and 0
> is unhandled.
Yes, You are right. Sorry I misread your reply about this. I will fix
this as you suggested.

jj
