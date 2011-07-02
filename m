Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1GBRLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:11:23 -0400
Received: from mail.southpole.se ([193.12.106.18]:34923 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1GBRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:11:19 -0400
Subject: Re: [PATCH 1/2] asm-generic: adapt delay.h to common implementation
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, lethal@linux-sh.org
In-Reply-To: <201107021321.10786.arnd@arndb.de>
References: <1309600754-21217-1-git-send-email-jonas@southpole.se>
	 <201107021321.10786.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Sat, 02 Jul 2011 19:11:15 +0200
Message-ID: <1309626675.24186.1268.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2011-07-02 at 13:21 +0200, Arnd Bergmann wrote:
> Very nice. Do you want to keep that in your own tree for your convenience,
> and merge it along with your architecture, or do you prefer me to
> take them into the asm-generic tree?

I can hang on to them for now.  If the architecture isn't ready for 3.1,
we can move them to your tree then.

> 
> If you want to add them to your tree, please add my
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Done.  Thanks,
Jonas

