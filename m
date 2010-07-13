Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0GMJMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:12:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41749 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0GMJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:12:24 -0400
Message-ID: <4C3C2DB1.8020705@ru.mvista.com>
Date: Tue, 13 Jul 2010 13:11:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building of tusb6010
References: <20100712224254.GA29115@shutemov.name>
In-Reply-To: <20100712224254.GA29115@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kirill A. Shutemov wrote:

>   CC      drivers/usb/musb/tusb6010.o
> drivers/usb/musb/tusb6010.c:34: error: expected identifier or '(' before 'do'
> drivers/usb/musb/tusb6010.c:34: error: expected identifier or '(' before 'while'
> drivers/usb/musb/tusb6010.c:39: error: expected identifier or '(' before 'do'
> drivers/usb/musb/tusb6010.c:39: error: expected identifier or '(' before 'while'
> make[2]: *** [drivers/usb/musb/tusb6010.o] Error 1
> make[1]: *** [drivers/usb/musb] Error 2
> make: *** [drivers] Error 2

> Empty musb_platform_save_context and musb_platform_restore_context
> provided by musb_core.h.

> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

    Such patch has already been submitted by Felipe Balbi:

http://marc.info/?l=linux-usb&m=127832134917692

WBR, Sergei
