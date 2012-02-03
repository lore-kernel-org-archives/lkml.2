Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2BCKvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:51:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53747 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2BCKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:51:15 -0500
Message-ID: <4F2BBBDA.90900@mvista.com>
Date: Fri, 03 Feb 2012 14:50:02 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] pch_udc: Specifies GPI port number at configuration.
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com> <1328253259-9343-3-git-send-email-tomoya.rohm@gmail.com>
In-Reply-To: <1328253259-9343-3-git-send-email-tomoya.rohm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-02-2012 11:14, Tomoya MORINAGA wrote:

> Problem:
>   The GPIO ports used for detecting VBUS may be different
>   on each platform.
>   This should be easily modifiable.
> Solution:
>   In configuration, GPI port number is specified.

    Isn't it better to pass this with driver's platform data.

> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

WBR, Sergei
