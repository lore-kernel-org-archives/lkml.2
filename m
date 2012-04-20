Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2DTSXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:23:14 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59303 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995Ab2DTSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:23:13 -0400
Message-ID: <4F91A94D.7070908@mvista.com>
Date: Fri, 20 Apr 2012 22:22:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: wim@iguana.be, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND v3] wdt: Device tree support for pnx4008-wdt
References: <1334933184-19418-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1334933184-19418-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/20/2012 06:46 PM, Roland Stigge wrote:

> This patch adds watchdog support to pnx4008-wdt.c

    s/watchdog/device tree/

> Signed-off-by: Roland Stigge<stigge@antcom.de>
> Reviewed-by: Arnd Bergmann<arnd@arndb.de>

WBR, Sergei
