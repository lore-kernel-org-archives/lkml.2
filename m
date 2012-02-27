Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2B0KxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:53:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62807 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2B0KxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:53:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sshtylyov@mvista.com designates 10.204.148.90 as permitted sender) smtp.mail=sshtylyov@mvista.com
Message-ID: <4F4B6046.7060606@mvista.com>
Date: Mon, 27 Feb 2012 14:51:50 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: balbi@ti.com, dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] amd5536udc: Fix the type of ep_string.
References: <4F48FD62.7090304@mvista.com> <1330268425-4260-1-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1330268425-4260-1-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-02-2012 19:00, Cyril Roelandt wrote:

> Use "static const char *const" instead of "static const char *".

> Signed-off-by: Cyril Roelandt<tipecaml@gmail.com>

    You should have added something like "v2" to the [PATCH] prefix, since you 
changed the patch, not just resent it...

WBR, Sergei
