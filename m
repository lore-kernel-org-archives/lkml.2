Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1DTWlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:41:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49528 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1DTWly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=POkVUWCEjVXAW37bOnuIlZw+CmVgi5S18xxZr82EpPGdtQEF4nv2Wwa1NYbc3zyBC6
         7PrWnvRIrD0LEkTJDEvHBamq0uPINhxFzehrHPvtKBw5PhrGvahQFIiUimYSFGnFn8ui
         elsIsz5XuJ/3GggPctpFnP4lB+jnyGRkcmYiM=
MIME-Version: 1.0
In-Reply-To: <1303337827.13259.2914.camel@petert>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com> <20110306073003.GA29325@angua.secretlab.ca>
 <1299467241.11719.145.camel@ptyser-laptop> <20110307070816.GC29999@angua.secretlab.ca>
 <1299544729.6057.73.camel@petert> <20110312091846.GJ9347@angua.secretlab.ca> <1303337827.13259.2914.camel@petert>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 20 Apr 2011 18:41:33 -0400
Message-ID: <BANLkTik-EabL9pkhiRr1ZLotr7fKKz11dg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 18:17, Peter Tyser wrote:
> I had a chance to look into this today, but had some follow up questions
> and comments.  There are a lot more GPIO drivers than expected...  How
> do the 94 driver changes get tested and applied?

one possibility:
 - one commit to add core functionality
 - one commit to convert all of the drivers under drivers/gpio/
 - one commit per arch/<arch>/

the first one you'd cc all arch maintainers, and the last one you can
cc each arch maintainer.  for the 2nd one, you can cc all the relevant
gpio people.
-mike
