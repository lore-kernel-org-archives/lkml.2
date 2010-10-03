Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0JCNdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:33:17 -0400
Received: from imr4.ericy.com ([198.24.6.8]:41035 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0JCNdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:33:16 -0400
Date: Sun, 3 Oct 2010 06:31:53 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Giel van Schijndel <me@mortis.eu>
CC: Laurens Leemans <laurens@signips.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Debian Bug #597820 <597820@bugs.debian.org>,
        Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: f71882fg: use a muxed resource lock for the
 Super I/O port
Message-ID: <20101003133153.GA31608@ericsson.com>
References: <20101003010635.GB29454@ericsson.com>
 <1286107790-26267-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286107790-26267-1-git-send-email-me@mortis.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 08:09:49AM -0400, Giel van Schijndel wrote:
> Sleep while acquiring a resource lock on the Super I/O port. This should
> prevent collisions from causing the hardware probe to fail with -EBUSY.
> 
> Signed-off-by: Giel van Schijndel <me@mortis.eu>

Applied.

Guenter
