Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0LRUN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 15:13:58 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55800 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab0LRUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:13:56 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 21:13:14 +0100
To: Ping Cheng <pinglinux@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce device information ioctl
Message-ID: <20101218201313.GA1675@polaris.bitmath.org>
References: <1292531413-28924-1-git-send-email-rydberg@euromail.se>
 <AANLkTimj3h_oVSj_QA5V=qB7WXXifbWcFtEgA6+6zPZc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimj3h_oVSj_QA5V=qB7WXXifbWcFtEgA6+6zPZc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PU39e-0004Ib-9X.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PU39e-0004Ib-9X 627ce7775e1b535f2543d57586fa143c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:24:44AM -0800, Ping Cheng wrote:
> On Thu, Dec 16, 2010 at 12:30 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Today, userspace sets up an input device based on the data it emits.
> > This is not always enough; a tablet and a touchscreen may emit exactly
> > the same data, for instance, but the former should be set up with a
> > pointer whereas the latter does not need to. Recently, a new type of
> > touchpad has emerged where the buttons are under the pad, which
> > changes handling logic without changing the emitted data. This patch
> > introduces a new ioctl, EVIOCGPROP, which enables user access to a set
> > of device properties useful during setup. The properties are given as
> > a bitmap in the same fashion as the event types, and are also made
> > available via sysfs.
> >
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Reviewed-by: Ping Cheng <pingc@wacom.com>
> 
> I wonder if we need to mention this new ioctl somewhere under
> Documentation/input or not. INPUT_PROP_SEMI_MT could add useful
> information for multi-touch-protocol.txt. The others could play a role
> in Chase's new Documentation/input/evdev-codes.txt.

Thank you, Ping - I added an acked-by to the last version by mistake,
instead of a reviewed-by. Is that alright with you? And yes, I think the
properties need to be documented somewhere.

Henrik
