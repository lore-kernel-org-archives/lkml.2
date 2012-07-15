Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab2GOTPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:15:47 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:59172 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2GOTPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:15:43 -0400
Message-ID: <500316DC.6060908@msgid.tls.msk.ru>
Date: Sun, 15 Jul 2012 23:15:40 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Reply-To: Linux-kernel <linux-kernel@vger.kernel.org>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rcX : Big problem with root device returning
References: <web-768955641@zbackend1.aha.ru> <4FFF0C8D.5000409@msgid.tls.msk.ru> <web-770074345@zbackend1.aha.ru>
In-Reply-To: <web-770074345@zbackend1.aha.ru>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.07.2012 23:12, werner wrote:

> Even if rdev isn't often used, it should kept working, as it's included in many other programs, and principally in the installers.

rdev doesn't _exist_ anymore in current software,
including installers.

/mjt
