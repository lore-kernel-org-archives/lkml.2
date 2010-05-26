Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab0EZSxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:53:34 -0400
Received: from xenotime.net ([72.52.115.56]:58163 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934236Ab0EZSxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:53:33 -0400
Date: Wed, 26 May 2010 11:53:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation: Short documentation for LP5521 and
 LP553 LED chips
Message-Id: <20100526115332.d4235020.rdunlap@xenotime.net>
In-Reply-To: <1274873354-1432-3-git-send-email-samu.p.onkalo@nokia.com>
References: <1274873354-1432-1-git-send-email-samu.p.onkalo@nokia.com>
	<1274873354-1432-3-git-send-email-samu.p.onkalo@nokia.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:29:14 +0300 Samu Onkalo wrote:

> Short documentation for National Semicondutor LP5521 and LP5523
> LED driver chip kernel drivers.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  Documentation/leds-lp5521.txt |   77 +++++++++++++++++++++++++++++++++++++++++
>  Documentation/leds-lp5523.txt |   73 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 150 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/leds-lp5521.txt
>  create mode 100644 Documentation/leds-lp5523.txt

Richard,

Also please do (something like):

$ mkdir Documentation/leds
$ mv Documentation/leds*.txt Documentation/leds/


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
