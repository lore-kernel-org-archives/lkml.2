Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2KPMJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:09:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64118 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2KPMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:09:30 -0500
Message-ID: <50A62CAB.90405@mvista.com>
Date: Fri, 16 Nov 2012 16:08:11 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: core: move dwc3_cache_hwparams before dwc3_alloc_event_buffers
References: <1353047874-4981-1-git-send-email-kishon@ti.com>
In-Reply-To: <1353047874-4981-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-11-2012 10:37, Kishon Vijay Abraham I wrote:

> commit 392142

    Please specify thta commit summary in parens.

> moved event buffer allocation out of dwc3_core_init() but
> event buffer allocation uses the cached copy of hwparams to determine
> the number of event buffers and the caching is done in dwc3_core_init.
> So moved dwc3_cache_hwparams function before dwc3_alloc_event_buffers so
> that dwc3_alloc_event_buffers sees the correct number of event buffers.

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

WBR, Sergei

