Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992562Ab2KODae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:30:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48554 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992461Ab2KODac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:30:32 -0500
Date: Wed, 14 Nov 2012 19:30:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
cc: Denys Fedoryshchenko <denys@visp.net.lb>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
 hwmon_device_unregister
In-Reply-To: <50A4606D.4020402@broadcom.com>
Message-ID: <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com>
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb> <50A4606D.4020402@broadcom.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:

> This was fixed by
> 
> commit de0a41484c47d783dd4d442914815076aa2caac2
> Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date:   Mon Oct 1 11:43:49 2012 -0400
> 
>     tg3: unconditionally select HWMON support when tg3 is enabled.
> 

Would you mind submitting this for stable by following the procedure 
described in Documentation/stable_kernel_rules.txt?
