Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2BZPDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:03:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65032 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2BZPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:03:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tipecaml@gmail.com designates 10.180.85.105 as permitted sender) smtp.mail=tipecaml@gmail.com; dkim=pass header.i=tipecaml@gmail.com
Message-ID: <4F4A483F.5050201@gmail.com>
Date: Sun, 26 Feb 2012 15:57:03 +0100
From: Cyril Roelandt <tipecaml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: balbi@ti.com, dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] amd5536udc: fix type of ep_string.
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com> <1330132502-17057-6-git-send-email-tipecaml@gmail.com> <4F48FD62.7090304@mvista.com>
In-Reply-To: <4F48FD62.7090304@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2012 04:25 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 25-02-2012 5:15, Cyril Roelandt wrote:
>
>> Use "static const char *" instead of "static const char *const".
>
> You're doing exactly oppposite.
>

Hello,

Thanks for pointing this out. Indeed, I made a mistake in the commit 
message. I'll resend this patch.

WBR,
Cyril Roelandt.

