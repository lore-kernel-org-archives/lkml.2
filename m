Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab1KITTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:19:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62832 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1KITTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:19:46 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111031440130.31612@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110182207500.5907@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111031440130.31612@chino.kir.corp.google.com>
Date: Wed, 9 Nov 2011 21:19:46 +0200
X-Google-Sender-Auth: MKmdqTfxH-r-NEW8CgbMjoy0Ln8
Message-ID: <CAOJsxLGOhW3tLTCZZw3VKoxd4Cg8ZN66ACj1vW3yQAFRenm3-A@mail.gmail.com>
Subject: Re: [patch 1/2] slab: rename slab_break_gfp_order to slab_max_order
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, David Rientjes wrote:
>> slab_break_gfp_order is more appropriately named slab_max_order since it
>> enforces the maximum order size of slabs as long as a single object will
>> still fit.
>>
>> Also rename BREAK_GFP_ORDER_{LO,HI} accordingly.

On Thu, Nov 3, 2011 at 11:40 PM, David Rientjes <rientjes@google.com> wrote:
> Ping on these two patches?  I don't see them in slab/next.

The patches seem reasonable to me. Christoph?
