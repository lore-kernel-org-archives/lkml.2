Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2JOG4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 02:56:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab2JOG4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 02:56:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Daniel Walter <sahne@0x90.at>
Cc: linux-pm@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: replace strict_str* with kstrto*
Date: Mon, 15 Oct 2012 08:59:56 +0200
Message-ID: <1860757.uv0ZbIMsfa@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120927123156.GA25811@elf.ucw.cz>
References: <20120926201506.GD1244@0x90.at> <20120927123156.GA25811@elf.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 of September 2012 14:31:56 Pavel Machek wrote:
> On Wed 2012-09-26 22:15:06, Daniel Walter wrote:
> > power: replace strict_strtoul with kstrtoul
> > 
> > Signed-off-by: Daniel Walter <sahne@0x90.at>
> 
> ACK.

Thanks!  I'll queue it up for v3.8 when I get back home from the current trip.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
