Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1KHOnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:43:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50359 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1KHOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <1320155902-10424-1-git-send-email-penberg@kernel.org>
References: <1320155902-10424-1-git-send-email-penberg@kernel.org>
Date: Tue, 8 Nov 2011 16:43:01 +0200
X-Google-Sender-Auth: Qwt_IA26SlytGzjbGwis9JwcjIo
Message-ID: <CAOJsxLHHpb93onT9OPW4Q5HXjSHPukz8CxFKEiyP5jCSYYPxkQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit
From: Pekka Enberg <penberg@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Arun Sharma <asharma@fb.com>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 3:58 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Use MAX_DMA_PFN which represents the 16 MB ISA DMA limit on 32-bit x86 just
> like we do on 64-bit.
>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

3.2-rc1 is out! Who do I have to bribe/sleep with to get this patch
series merged to -tip?
