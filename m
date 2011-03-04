Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab1CDMwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:52:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47042 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab1CDMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:52:42 -0500
Date: Fri, 4 Mar 2011 12:52:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304125239.GE17653@sirena.org.uk>
References: <20110303204749.GY3663@linux.intel.com> <20110303211336.GA32645@kroah.com> <20110303214104.GZ3663@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303214104.GZ3663@linux.intel.com>
X-Cookie: There are no games on this system.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 04:41:04PM -0500, Matthew Wilcox wrote:

> There's a bit of an impedence mismatch there.  Think of this as
> being drive firmware instead of controller firmware.  This isn't for
> request_firmware() kind of uses, it's for some admin tool to come along
> and tell the drive "Oh, here's some new firmware for you".

What some other devices I've seen do for this is expose the firmware
storage as a MTD device.  Dunno if that matches the hardware at all
here, though.
