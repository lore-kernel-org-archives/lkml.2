Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1CNXnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:43:41 -0400
Received: from trinity.fluff.org ([89.16.178.74]:33951 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1CNXnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:43:41 -0400
Date: Mon, 14 Mar 2011 23:43:37 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 00/13]  V3 Split i2c-designware.c to support PCI
	drivers.
Message-ID: <20110314234337.GN15795@trinity.fluff.org>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 12:23:14PM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch set reworks i2c-designware.c to enable supporting multiple
> instances of the driver in the system and adds support for Designware
> I2C IP cores behind PCI devices.
> 
> The patch set has been refactored to hopefully make it easier to
> review.
> 
> TODO:
> Ben disliked the module names, they haven't changed yet waiting for
> feedback on the list.

Right, merged into next-i2c pending any further feedback.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

