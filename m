Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2DPNMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:12:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2DPNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:12:21 -0400
Date: Mon, 16 Apr 2012 14:12:16 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: amilo-rfkill: unsupported platform
Message-ID: <20120416131216.GA4047@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

You have recently submitted a new rfkill driver for the Amilo A1655 and
M7440 models.  We have been using the fsam7400 driver[1] for the Amilo
M7440 and it would probably make sense to merge it into the amilo-rfkill.

However, the fsam7400 driver directly invokes BIOS code in order to turn
on/off the radio, instead of the methods used by the A1655 and M7440
driver.  This means the memory pages with the BIOS code would need to be
set as executable after the ioremap (which is probably a bad idea).

Are there any plans of merging this driver into the amilo-rfkill driver?

[1] http://www.iragan.com/linux/fsam7400/

Cheers,
--
Luis
