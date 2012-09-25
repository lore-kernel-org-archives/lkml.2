Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2IYI4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:56:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54926 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2IYI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:56:33 -0400
Message-ID: <506171BD.8020207@gmail.com>
Date: Tue, 25 Sep 2012 10:56:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ARM: dove: Fix tauros2 device tree init
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com> <1348531338-16624-3-git-send-email-sebastian.hesselbarth@gmail.com> <5061073C.4010002@gmail.com> <20120925051934.GJ14266@lunn.ch>
In-Reply-To: <20120925051934.GJ14266@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 07:19 AM, Andrew Lunn wrote:
> Interestingly, kisskb does not show this break:
>
> http://kisskb.ellerman.id.au/kisskb/config/308/
>
> and yesterdays build does not have the parameter to tauros2_init().
> Is the cache not enabled in dove_defconfig?

Andrew,

I checked dove_defconfig and CONFIG_CACHE_TAUROS2 is not set.
I put it on my list for the next release cycle.

Interestingly, the mmp guys changed the parameter within
non-DT dove_init.

Sebastian

