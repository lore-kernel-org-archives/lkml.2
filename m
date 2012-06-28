Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2F1HIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:08:44 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:30046 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2F1HIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:08:43 -0400
Date: Thu, 28 Jun 2012 09:08:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8 v3] i2c: i801: check and return errors during 
 byte-by-byte transfers
Message-ID: <20120628090828.47b5aff8@endymion.delvare>
In-Reply-To: <CAGS+omDkhA=dP0JP=4huQEwJ4j6YqZWJ+mFsJv+eeGMBRpu5fQ@mail.gmail.com>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-5-git-send-email-djkurtz@chromium.org>
	<20120627185136.315e6625@endymion.delvare>
	<CAGS+omDkhA=dP0JP=4huQEwJ4j6YqZWJ+mFsJv+eeGMBRpu5fQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 11:46:28 +0800, Daniel Kurtz wrote:
> On Thu, Jun 28, 2012 at 12:51 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Wed, 27 Jun 2012 21:54:11 +0800, Daniel Kurtz wrote:
> >> If an error is detected in the polling loop, abort the transaction and
> >> return an error code.
> >>
> >>  * DEV_ERR is set if the device does not respond with an acknowledge, and
> >> the SMBus controller times out (minimum 25ms).
> >>  * BUS_ERR is set if a bus arbitration collision is detected.  In other
> >> words, when the SMBus controller tries to generate a START condition, but
> >> detects that the SMBDATA is being held low, usually by another SMBus/I2C
> >> master.
> >>  * FAILED is only set if a the transaction is set by software (using the
> >> SMBHSTCNT KILL bit).
> 
> That was supposed to say:
> 
>  * FAILED is only set if a transaction is stopped by software (using
> the SMBHSTCNT KILL bit).

Changed, thanks!

> > Not quite sure what you mean with "set by software". Other than this,
> > patch looks good, applied, thanks.
> 
> Applied where?
> I'd like to send a rebased patchset onto whatever you have already staged.

http://khali.linux-fr.org/devel/linux-3/jdelvare-i2c/

-- 
Jean Delvare
