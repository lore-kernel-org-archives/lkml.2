Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2LVRw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:52:57 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:57651 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2LVRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:52:55 -0500
Message-ID: <50D5F36F.3070707@mvista.com>
Date: Sat, 22 Dec 2012 21:52:47 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
CC: balbi@ti.com, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] arm/davinci/musb: fix mispint introduced by commit 032ec49f5351e9cb242b1a1c367d14415043ab95
References: <1356040747-15105-1-git-send-email-mikhail.kshevetskiy@gmail.com> <20121221090625.GA31453@arwen.pp.htv.fi>
In-Reply-To: <20121221090625.GA31453@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-12-2012 13:06, Felipe Balbi wrote:

> please respin this patch with a real commit log.

    And then, when referring to commit ID that broke da8xx.c don't forget to 
also specify the commit summmary in parens (or however you like).

>> Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

WBR, Sergei

