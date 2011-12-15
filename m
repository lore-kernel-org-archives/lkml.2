Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629Ab1LOWgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:36:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab1LOWgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:36:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update][PATCH 0/5] PM: Make the PM core execute driver callbacks if subsystem ones are not present
Date: Thu, 15 Dec 2011 23:34:16 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Namhyung Kim <namhyung@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201112100018.38536.rjw@sisk.pl>
In-Reply-To: <201112100018.38536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112152334.16527.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one more patch for this series and a couple of fixes.

On Saturday, December 10, 2011, Rafael J. Wysocki wrote:
> 
> The following patchset changes the PM core so that driver callbacks
> are executed automatically when subsystem ones are not present and
> uses the new PM core's behavior to simplify the platform and AMBA bus
> types (there probably are many more bus types that may be simplified
> this way, but those two were the easiest targets for me).
> 
> The reasons why to do this are outlined in the changelog of the second patch.

[1/5] - Make pm_op and pm_noirq_op return callbacks
[2/5] - Make PM core call driver callbacks directly if subsystem ones are not present
[3/5] - Remove unnecessary bus type PM callback from platform bus type
[4/5] - Remove unnecessary bus type PM callback from AMBA bus type
[5/5] - Drop generic_subsys_pm_ops

If there are no objections, I'd like to take these patches for 3.3.

Thanks,
Rafael
