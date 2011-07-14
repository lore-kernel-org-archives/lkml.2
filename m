Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1GNNZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:25:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1GNNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:25:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
Date: Thu, 14 Jul 2011 15:24:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Andreas Bombe <aeb@debian.org>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107141524.31599.arnd@arndb.de>
X-Provags-ID: V02:K0:TnoMLpoycebboqEvgUg88x4MuNdUN2Xh9VMO24eFtYc
 GSV9j63wnGPPeQ6+BpVoYLiwTnVRYcp5ChiKKdvGsQZadxbdhj
 hjusqzzn9+ysSzTthsIgoZGGXxKzzIXI+d/9EL09WVB/w/hCKv
 HMYE6k/nBIc+Nc2i+9fklegOCatdcXvJUr6IYatXHot7RLqeFI
 3nVb2OmvMhoznYMXY5tyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 July 2011, Jiri Slaby wrote:
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> References: https://lkml.org/lkml/2011/5/25/562
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andreas Bombe <aeb@debian.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
