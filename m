Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1DYUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:09:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1DYUJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:09:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>, "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH] PM / Wakeup: Fix initialization of wakeup-related device sysfs files
Date: Mon, 25 Apr 2011 22:10:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104212357.43052.rjw@sisk.pl> <20110425195811.GA3407@mac.home>
In-Reply-To: <20110425195811.GA3407@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104252210.16719.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 25, 2011, Tino Keitel wrote:
> Hi,
> 
> the patch works fine on top of current git
> (8f7544682c488dfc4117b37ed10435bb2d3d8d73). Wakeup using the keyboard
> works.

Great, thanks for testing.

Greg, are you fine with https://lkml.org/lkml/2011/4/21/404 ?

Rafael

