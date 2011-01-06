Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1AFVME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:12:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36895 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1AFVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:12:01 -0500
Date: Thu, 6 Jan 2011 13:08:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RESEND #2] [PATCH v2] LEDS: Add output invertion option to
 backlight trigger
Message-Id: <20110106130856.22b92a8b.randy.dunlap@oracle.com>
In-Reply-To: <20110106130440.cfd77c8e.akpm@linux-foundation.org>
References: <201012091441.51846.jkrzyszt@tis.icnet.pl>
	<20110106130440.cfd77c8e.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 13:04:40 -0800 Andrew Morton wrote:

> On Thu, 9 Dec 2010 14:41:50 +0100
> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:
> 
> > +static DEVICE_ATTR(invert, 0644, bl_trig_invert_show, bl_trig_invert_store);
> 
> This new sysfs file should be documented.  Where would be an
> appropriate place for that?  Documentation/leds-class.txt doesn't
> mention a sysfs API at all.  
> --

in Documentation/ABI/, where all sysfs interface info lives.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
