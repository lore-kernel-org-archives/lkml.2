Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab1DYT5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:57:52 -0400
Received: from eazy.amigager.de ([213.239.192.238]:49983 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab1DYT5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:57:51 -0400
Date: Mon, 25 Apr 2011 21:58:11 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] PM / Wakeup: Fix initialization of wakeup-related device
 sysfs files
Message-ID: <20110425195811.GA3407@mac.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <201104212357.43052.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104212357.43052.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch works fine on top of current git
(8f7544682c488dfc4117b37ed10435bb2d3d8d73). Wakeup using the keyboard
works.

Regards,
Tino
