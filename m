Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1CHMPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:15:03 -0500
Received: from www.tglx.de ([62.245.132.106]:54281 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab1CHMPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:15:00 -0500
Date: Tue, 8 Mar 2011 13:14:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sgruszka@redhat.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debugobjects] debugobjects: Add hint for better object
 identification
In-Reply-To: <tip-be1e60006500eebfb3b82e0c0915ea898dfd224e@git.kernel.org>
Message-ID: <alpine.LFD.2.00.1103081314100.2787@localhost6.localdomain6>
References: <20110307085809.GA9334@redhat.com> <tip-be1e60006500eebfb3b82e0c0915ea898dfd224e@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, tip-bot for Stanislaw Gruszka wrote:
>  
> +static void *work_debug_hint(void *addr)
> +{
> +	return ((struct work_struct *work) addr)->func;
> +}

Care to send compilable patches ?

Thanks,

	tglx
