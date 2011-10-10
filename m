Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1JJVoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:44:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab1JJVoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:44:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_delay kernel param as well as resume_delay
Date: Mon, 10 Oct 2011 23:46:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Barry Song <Barry.Song@csr.com>, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Barry Song <baohua.song@csr.com>
References: <1318225452-10397-1-git-send-email-Barry.Song@csr.com> <20111010165437.GA11093@elf.ucw.cz>
In-Reply-To: <20111010165437.GA11093@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110102346.41331.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 10, 2011, Pavel Machek wrote:
> On Sun 2011-10-09 22:44:12, Barry Song wrote:
> > From: Barry Song <baohua.song@csr.com>
> > 
> > patch "PM: HIBERNATION: add resume_wait param to support MMC-like devices
> > as resume file" add resume_wait param. this patch adds resume_delay so that
> > resume_wait/delay has the same model with root_wait/delay.
> > 
> > Signed-off-by: Barry Song <baohua.song@csr.com>
> 
> ACK.

Applied to linux-pm/linux-next.

Thanks,
Rafael
