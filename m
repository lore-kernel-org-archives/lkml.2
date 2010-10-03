Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0JCJBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 05:01:50 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15164 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0JCJBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 05:01:49 -0400
Date: Sun, 3 Oct 2010 11:01:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Giel van Schijndel <me@mortis.eu>, Hans de Goede <hdegoede@redhat.com>,
        Laurens Leemans <laurens@signips.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "597820@bugs.debian.org" <597820@bugs.debian.org>
Subject: Re: [PATCH 1/2] hwmon: f71882fg: use a muxed resource lock for the
  Super I/O port
Message-ID: <20101003110110.49b3caf4@endymion.delvare>
In-Reply-To: <20101003010635.GB29454@ericsson.com>
References: <20100801132226.GE3711@salidar.me.mortis.eu>
	<1280669455-31283-1-git-send-email-me@mortis.eu>
	<4C59514A.7090401@redhat.com>
	<20101002225958.GA18605@salidar.me.mortis.eu>
	<20101003010635.GB29454@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010 18:06:35 -0700, Guenter Roeck wrote:
> On Sat, Oct 02, 2010 at 06:59:58PM -0400, Giel van Schijndel wrote:
> > On Wed, Aug 04, 2010 at 01:38:50PM +0200, Hans de Goede wrote:
> > > Ack!
> > > 
> > > Acked-by: Hans de Goede <hdegoede@redhat.com>
> > > 
> > > On 08/01/2010 03:30 PM, Giel van Schijndel wrote:
> > >> Sleep while acquiring a resource lock on the Super I/O port. This should
> > >> prevent collisions from causing the hardware probe to fail with -EBUSY.
> > >> 
> > >> Signed-off-by: Giel van Schijndel<me@mortis.eu>
> > 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Jean, if it is ok with you, I can apply it to my tree.

I have no objection. I never had the time to look at these patches, and
won't have it any time soon. So I'm very happy if you can handle them.

> I tried to find the patch on the web in downloadable form, but didn't find
> the correct version of it. So it would be great if you could re-send it.

-- 
Jean Delvare
