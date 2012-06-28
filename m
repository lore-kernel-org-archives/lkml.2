Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2F1GFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:05:00 -0400
Received: from gherkin.frus.com ([192.158.254.49]:52276 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2F1GE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:04:59 -0400
Date: Thu, 28 Jun 2012 01:04:56 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: Re: no USB keyboard in 3.5-rc1 and later
Message-ID: <20120628060456.GA2132@gherkin.frus.com>
References: <20120627013031.GA2681@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627013031.GA2681@gherkin.frus.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 08:30:31PM -0500, Bob Tracy wrote:
> Here's hoping it's something simple.  Attached USB devices fail to
> initialize/work for kernel version 3.5-rc1 and later (up through
> 3.5-rc4).  From what I can tell from the dmesg output (attached),
> there used to be an "input" or "generic-usb" message that appeared
> for each device following detection -- showing the sysfs path to the
> device.

The answer *was* simple: the deprecated usbfs under /proc went bye-bye
starting with 3.5-rc1.  I'm still using a static "/dev" (no "udev").
Hence, no device nodes under "/dev/bus/usb".

--Bob
