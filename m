Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab0JDUfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:35:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43832 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab0JDUfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:35:00 -0400
Message-ID: <4CAA3A69.9040709@zytor.com>
Date: Mon, 04 Oct 2010 13:34:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@suse.de, autofs@linux.kernel.org, Ian Kent <raven@themaw.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] autofs3: move to drivers/staging
References: <201010042228.10642.arnd@arndb.de>
In-Reply-To: <201010042228.10642.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 01:28 PM, Arnd Bergmann wrote:
> Nobody appears to be interested in fixing autofs3 bugs
> any more and it uses the BKL, which is going away.
> 
> Move this to staging for retirement. Unless someone
> complains until 2.6.38, we can remove it for good.
> 
> The include/linux/auto_fs.h header file is still used
> by autofs4, so it remains in place.

I say we should just delete it.

	-hpa
