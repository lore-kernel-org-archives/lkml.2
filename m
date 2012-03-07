Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2CGKI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:08:26 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42706 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964Ab2CGKIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:08:24 -0500
Date: Wed, 7 Mar 2012 12:08:19 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: linux-kernel@vger.kernel.org, leonid.moiseichuk@nokia.com,
        David Rientjes <rientjes@google.com>, mingo@elte.hu
Subject: Re: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd()
 ABI
In-Reply-To: <20120306225937.GA24931@oksana.dev.rtsoft.ru>
Message-ID: <alpine.LFD.2.02.1203071203320.1774@tux.localdomain>
References: <1331067079-2163-1-git-send-email-penberg@kernel.org> <20120306225937.GA24931@oksana.dev.rtsoft.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Anton Vorontsov wrote:
> Sorry for hijacking this thread, but speaking of big
> changes. Are there any plans or ideas to add other methods
> of sampling, i.e. something not timer-based?

Yes and no.

Linux already has non-timer based "vm events" via tracepoints. There's 
absolutely no need to reinvent the wheel so we should integrate with perf 
more closely.

The biggest open question is whether or not a new syscall is needed for 
configuring memory thresholds and such.

			Pekka
