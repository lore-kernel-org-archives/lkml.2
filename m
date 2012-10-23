Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2JWSnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:43:11 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39884 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2JWSnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <0000013a8ed646c2-4cc34bd5-19c3-4e99-9fa0-248cdbc24feb-000000@email.amazonses.com>
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com>
	<0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com>
	<CALF0-+VqGrcjw16rNPH459YAj7dubQnruzV-zOzYn6feOtQ4tQ@mail.gmail.com>
	<0000013a8ed646c2-4cc34bd5-19c3-4e99-9fa0-248cdbc24feb-000000@email.amazonses.com>
Date: Tue, 23 Oct 2012 15:43:09 -0300
Message-ID: <CALF0-+WASdSAT9rnLxx8OmHrNV5tjrDwpBTE9irCRd91QxMkBA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at /proc/meminfo
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:15 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 22 Oct 2012, Ezequiel Garcia wrote:
>
>> SLUB handles large kmalloc allocations falling back
>> to page-size allocations (kmalloc_large, etc).
>> This path doesn't touch NR_SLAB_XXRECLAIMABLE zone item state.
>
> Right. UNRECLAIMABLE allocations do not factor in reclaim decisions.
>

I wasn't asking about reclaim decisions.

I think my question wasn't clear.

The issue is: with SLUB large kmallocs don't set NR_SLAB_UNRECLAIMABLE
zone item.
Thus, they don't show at /proc/meminfo. Is this okey?

Thanks!

    Ezequiel
