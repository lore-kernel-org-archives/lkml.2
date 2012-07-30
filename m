Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2G3T3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:29:09 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43191 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2G3T3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:29:04 -0400
Message-ID: <5016E06E.3060609@ahsoftware.de>
Date: Mon, 30 Jul 2012 21:28:46 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video/smscufx: fix line counting in fb_write
References: <1334959867-3719-1-git-send-email-holler@ahsoftware.de> <4F92995B.6030805@ahsoftware.de> <4FAFAD7B.6090207@gmx.de> <4FF211BD.8060203@ahsoftware.de> <50117DD9.6070200@gmx.de>
In-Reply-To: <50117DD9.6070200@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 26.07.2012 19:26, schrieb Florian Tobias Schandinat:

> Well, as this patch fixes a bug I applied it as is.

Thanks a lot, actually I was more interested to get that one-line-patch 
for udlfb, because I've discovered that bug using one of those Mimo-LCDs. ;)

Are you responsible for that too?

Regards,

Alexander
