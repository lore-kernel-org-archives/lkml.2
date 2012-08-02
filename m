Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2HBT5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 15:57:45 -0400
Received: from seven.medozas.de ([5.9.24.206]:55058 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab2HBT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 15:57:44 -0400
Date: Thu, 2 Aug 2012 21:57:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] netconsole.txt: "nc" needs "-p" to specify the
 listening port
In-Reply-To: <gir4rxk7c2.fsf@mx10.gouders.net>
Message-ID: <alpine.LNX.2.01.1208022156280.30631@frira.zrqbmnf.qr>
References: <gir4rxk7c2.fsf@mx10.gouders.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-07-27 08:35, Dirk Gouders wrote:
>diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
>index 8d02207..ffe30a7 100644
>--- a/Documentation/networking/netconsole.txt
>+++ b/Documentation/networking/netconsole.txt
>@@ -52,7 +52,7 @@ initialized and attempts to bring up the supplied dev at the supplied
> address.
> 
> The remote host can run either 'netcat -u -l -p <port>',
>-'nc -l -u <port>' or syslogd.
>+'nc -l -u -p <port>' or syslogd.

While at it, could you add

  socat udp-recv:<port> -

since netcat is _really_ archaic ;-)

