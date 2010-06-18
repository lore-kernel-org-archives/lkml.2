Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab0FROUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:20:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64257 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab0FROT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:19:59 -0400
Message-ID: <4C1B8055.30904@mvista.com>
Date: Fri, 18 Jun 2010 18:19:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
CC: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 10/11] USB: gadget: composite: addad disconnect callback
References: <20100615185527.GA22803@kroah.com> <cover.1276681840.git.m.nazarewicz@samsung.com> <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com> <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com> <0022e21e1b622b3a54d1e55aed727e7e429c7c70.1276681840.git.m.nazarewicz@samsung.com> <45fc10256bd2374706e4153360427257d15804a9.1276681840.git.m.nazarewicz@samsung.com> <bb0d9f73c7caae31c0bc291d3dfce44a2f6a3736.1276681840.git.m.nazarewicz@samsung.com> <c7fbb2934e18cfd25df3e00a548ac33e5b0a7353.1276681840.git.m.nazarewicz@samsung.com> <9f32ae2ab133d27642ac4c1e81777b1e34a0c1a1.1276681840.git.m.nazarewicz@samsung.com> <c4143e7fdd0fc61f05118c30a0a9edbbc0a97db4.1276681840.git.m.nazarewicz@samsung.com> <0de8ae564d9a562ee02bfb116b3a6bf0ff19ea3f.1276681840.git.m.nazarewicz@samsung.com> <42fc529dec5034b62c17d00791e4fe8b8d5f19ee.1276681840.git.m.nazarewicz@samsung.com> <4C1A0141.5020003@ru.mvista.com>
In-Reply-To: <4C1A0141.5020003@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I wrote:

> Michal Nazarewicz wrote:

>> Added a disconnect() callback to compasite devices which

>    Your subject has "addad" -- probably instead of "added".

    Also, there's typo in the first line: "compasite"...

>> is called by composite glue when its disconnect callback
>> is called by gadget.

>> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

WBR, Sergei
