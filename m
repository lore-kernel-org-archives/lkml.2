Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1GYSQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:16:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59801 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1GYSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:16:52 -0400
Date: Mon, 25 Jul 2011 11:16:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: rydberg@euromail.se, chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 8/9 v2] Input: add BTN_TOOL_QUINTTAP for reporting 5
 fingers on touchpad
Message-ID: <20110725181645.GA6876@core.coreip.homeip.net>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-9-git-send-email-djkurtz@chromium.org>
 <20110725082918.GC22937@core.coreip.homeip.net>
 <CAGS+omAQmb-q6xC-Gh6z69iNNyr=rN-Khsq90aCHJwe-6F9ANw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omAQmb-q6xC-Gh6z69iNNyr=rN-Khsq90aCHJwe-6F9ANw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 05:14:22PM +0800, Daniel Kurtz wrote:
> On Mon, Jul 25, 2011 at 4:29 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > On Wed, Jul 20, 2011 at 09:39:05PM +0800, djkurtz@chromium.org wrote:
> > > From: Daniel Kurtz <djkurtz@chromium.org>
> > >
> >
> > Do we know what we want to do with this gesture? Because if not I'd
> > rather not merge it for now, until there are real users.
> 
> And do what instead?
> Report 5 fingers with BTN_TOOL_QUADTAP?
> 

That, or nothing... The fact that the device can report 5 finger touch
does not mean that anybody cares about this.

-- 
Dmitry
