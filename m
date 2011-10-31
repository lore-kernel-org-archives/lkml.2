Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab1JaSai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 14:30:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56461 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659Ab1JaSah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 14:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <1319811801-1725-1-git-send-email-penberg@kernel.org>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org>
Date: Mon, 31 Oct 2011 11:30:37 -0700
X-Google-Sender-Auth: FQLxcJFh3JYs5SHmBBln03Mh6Hk
Message-ID: <CAE9FiQXB6T870YnRBeQ1-8H6XxRteLpEuaSDWO1KVZuLRk0B0A@mail.gmail.com>
Subject: Re: [RFC/PATCH 1/7] x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit
From: Yinghai Lu <yinghai@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 7:23 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Use MAX_DMA_PFN which represents the 16 MB ISA DMA limit on 32-bit x86 just
> like we do on 64-bit.
>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

for this patch set:

Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks

Yinghai
