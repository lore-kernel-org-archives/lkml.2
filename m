Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0FRV0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:26:12 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38698 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0FRV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:26:09 -0400
Message-ID: <4C1BE436.4090805@ru.mvista.com>
Date: Sat, 19 Jun 2010 01:25:10 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
CC: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6.1 06/11] USB: gadget: g_multi: code clean up and refactoring
References: <2809a031d19ac6ef793d7fe343e225b8d80099c3.1276871819.git.m.nazarewicz@samsung.com>
In-Reply-To: <2809a031d19ac6ef793d7fe343e225b8d80099c3.1276871819.git.m.nazarewicz@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michal Nazarewicz wrote:

> The Multifunction Compasite Gadget have been cleaned up

    Looks like I'll be your spell-checker for a while. Fix "compasite" here as 
well please.

> and refactored so hopefully it looks prettier and works
> at least as good as before changes.

> Among other things this also prevents the possibility to
> select no configuration with Kconfig options which would
> result in an unusable driver.

> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

WBR, Sergei
