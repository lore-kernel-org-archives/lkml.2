Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3AERwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:52:32 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:61351 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3AERw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:52:26 -0500
Message-ID: <50E875F2.5070900@mvista.com>
Date: Sat, 05 Jan 2013 21:50:26 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
CC: balbi@ti.com, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] arm/davinci/musb: fix mispint introduced by commit 032ec49f5351e9cb242b1a1c367d14415043ab95
References: <1356040747-15105-1-git-send-email-mikhail.kshevetskiy@gmail.com> <20121221090625.GA31453@arwen.pp.htv.fi> <50D5F36F.3070707@mvista.com>
In-Reply-To: <50D5F36F.3070707@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 08:52 PM, Sergei Shtylyov wrote:

>> please respin this patch with a real commit log.

>    And then, when referring to commit ID that broke da8xx.c don't forget to also
> specify the commit summmary in parens (or however you like).

   Also, please s/davinci/da8xx/ in the subject. OMAP-L1x/DA8xx is not exactly
DaVinci.

>>> Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

WBR, Sergei

