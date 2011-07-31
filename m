Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1GaRhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:37:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59192 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GaRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:37:07 -0400
Message-ID: <4E3592BF.5070606@gmail.com>
Date: Sun, 31 Jul 2011 19:37:03 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile, x86: Move memory allocation to init
References: <4E3587C0.4040406@gmail.com>
In-Reply-To: <4E3587C0.4040406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2011 06:50 PM, Maarten Lankhorst wrote:
> ppro_setup_ctrs is called on all cpu's, while init is only called once.
>
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>
> ---
> Fixes oprofile on 3.0 rt6.
>
Not correct for the PPRO case, will send a revised patch shortly. Also seems I cant do kfree on shutdown, so I'll do it on exit.
