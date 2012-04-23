Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2DWV25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:28:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2DWV2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:28:55 -0400
Date: Mon, 23 Apr 2012 17:28:48 -0400 (EDT)
Message-Id: <20120423.172848.1733968863825393980.davem@davemloft.net>
To: smhodgson@solarflare.com
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com, bruce.w.allan@intel.com,
        decot@google.com, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] Add capability to retrieve plug-in module
 EEPROM
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9031BF.10106@solarflare.com>
References: <4F9031BF.10106@solarflare.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Apr 2012 14:28:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You can't just submit three seperate patches each with the same exact
Subject line.

Otherwise someone scanning the commit headers can't figure out what
is different in each of these changes.

There also is no signoff from Ben for patches #2 or #3, did he review
them?  If so, why didn't he ACK or sign off on it?  If not, why not?
