Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936724Ab0COUcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:32:13 -0400
Received: from xenotime.net ([72.52.64.118]:46226 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936684Ab0COUcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:32:10 -0400
Message-ID: <4B9E9946.20001@xenotime.net>
Date: Mon, 15 Mar 2010 13:32:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Update device power management document
References: <201003142103.19420.rjw@sisk.pl> <4B9DA9F4.7040906@xenotime.net> <201003152104.24882.rjw@sisk.pl>
In-Reply-To: <201003152104.24882.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/10 13:04, Rafael J. Wysocki wrote:
> 
> Updated patch is appended.
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Update device power management document
> 
> The device PM document, Documentation/power/devices.txt, is badly
> outdated and requires total rework to fit the current design of the
> PM framework.  Make it more up to date.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  Documentation/power/devices.txt |  722 ++++++++++++++++++++++++----------------
>  1 file changed, 443 insertions(+), 279 deletions(-)
> 
> Index: linux-2.6/Documentation/power/devices.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/devices.txt
> +++ linux-2.6/Documentation/power/devices.txt


-- 
~Randy
