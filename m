Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0G3RIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:08:31 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:56408 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0G3RIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:08:30 -0400
Date: Fri, 30 Jul 2010 19:08:09 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/6] cris: Pushdown the bkl from ioctl
Message-ID: <20100730170809.GD9784@axis.com>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278195310-25590-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 12:15:08AM +0200, Arnd Bergmann wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Pushdown the bkl to the remaining drivers using the
> deprecated .ioctl.

Thanks, I've pushed this change to the cris tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
