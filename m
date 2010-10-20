Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0JTQqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:46:55 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38089 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0JTQqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:46:54 -0400
Date: Wed, 20 Oct 2010 18:46:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>, Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020184640.0df26e35@endymion.delvare>
In-Reply-To: <20101020164343.GA22572@ericsson.com>
References: <1287530020.10409.594.camel@Joe-Laptop>
	<20101020032938.GA20095@ericsson.com>
	<1287545658.10409.606.camel@Joe-Laptop>
	<20101020035346.GA20178@ericsson.com>
	<1287547662.10409.618.camel@Joe-Laptop>
	<20101020093438.07b129c8@endymion.delvare>
	<20101020144608.GA21937@ericsson.com>
	<20101020183835.202989c9@endymion.delvare>
	<20101020164343.GA22572@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 09:43:43 -0700, Guenter Roeck wrote:
> On Wed, Oct 20, 2010 at 12:38:35PM -0400, Jean Delvare wrote:
> > But first of all, I really would like the pr_fmt issue do be sorted
> > out. I don't like the idea of having to redefine it in every driver,
> > when it seems easy to avoid that. Joe?
>
> Agreed, especially since it doesn't seem to be used in many of the drivers.

As I understand it, it's used silently by all pr_*() calls.

-- 
Jean Delvare
