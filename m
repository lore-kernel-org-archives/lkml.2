Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2HPN4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:56:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab2HPN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:56:34 -0400
Message-ID: <502CFC0E.9020907@suse.cz>
Date: Thu, 16 Aug 2012 15:56:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] TTY: tty_alloc_driver() returns error pointers
References: <20120816131656.GB23279@elgon.mountain>
In-Reply-To: <20120816131656.GB23279@elgon.mountain>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 03:16 PM, Dan Carpenter wrote:
> We changed these from alloc_tty_driver() to tty_alloc_driver() so the
> error handling needs to modified to check for IS_ERR() instead of NULL.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Shame.

Acked-by: Jiri Slaby <jslaby@suse.cz>

thanks,
-- 
js
suse labs
