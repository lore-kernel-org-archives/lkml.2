Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0KBUo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:44:26 -0400
Received: from ifup.org ([198.145.64.140]:40429 "EHLO ifup.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0KBUoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:44:24 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2010 16:44:24 EDT
Date: Tue, 2 Nov 2010 10:04:08 -0700
From: Brandon Philips <brandon@ifup.org>
To: Haiyang Zhang <haiyangz@linuxonhyperv.com>
Cc: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 05/10] staging: hv: Convert camel cased functions in
 hv.c to lower cases
Message-ID: <20101102170406.GA4557@jenkins.home.ifup.org>
References: <1288644369-12958-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-5-git-send-email-haiyangz@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288644369-12958-5-git-send-email-haiyangz@linuxonhyperv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:46 Mon 01 Nov 2010, Haiyang Zhang wrote:
> -static int HvQueryHypervisorInfo(void)
> +static int hvquery_hypervisor_info(void)
> -static u64 HvDoHypercall(u64 control, void *input, void *output)
> +static u64 hvdo_hypercall(u64 control, void *input, void *output)

Should these be hv_do_hypercall and hv_query_hypervisor? That seems to
be the style in the rest of the patch:

> -int HvInit(void)
> +int hv_init(void)

> -void HvCleanup(void)
> +void hv_cleanup(void)

> -u16 HvPostMessage(union hv_connection_id connection_id,
> +u16 hv_post_message(union hv_connection_id connection_id,

> -u16 HvSignalEvent(void)
> +u16 hv_signal_event(void)

Cheers,

	Brandon
