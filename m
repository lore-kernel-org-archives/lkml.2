Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1DSUVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:21:53 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44282 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab1DSUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:21:50 -0400
Date: Tue, 19 Apr 2011 22:22:12 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] /proc/acpi/wakeup regression in 2.6.39-rc3
Message-ID: <20110419202212.GA15438@mac.home>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <201104150053.37037.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1104151034580.2051-100000@iolanthe.rowland.org>
 <20110415145457.GA27650@eazy.amigager.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415145457.GA27650@eazy.amigager.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I reverted some wakeup and ACPI related commits. When I reverted commit
7fa69baf29de8c77a6b32c054df2abb8f11f8aa4, wakeup using the keyboard
worked again and /proc/acpi/wakeup behaved as expected.

So check this, I reverted the following commits to avoid conflicts and
build failures:

c19f9a84ec807da57fd75bbd9a3f2b8269611f79
5190726765b40774c069e187a958e10ccd970e65
2a5d24286e8bdafdc272b37ec5bdd9e977b3767c
f2b56bc808addb908a5bf435d9b942c02af9a7c4
7fa69baf29de8c77a6b32c054df2abb8f11f8aa4

Regards,
Tino
