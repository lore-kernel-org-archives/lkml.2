Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0GDQvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 12:51:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36000 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0GDQvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 12:51:03 -0400
Message-ID: <4C30BBF0.1030801@cs.helsinki.fi>
Date: Sun, 04 Jul 2010 19:50:56 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Xiaotian Feng <dfeng@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH V2] slab: fix caller tracking on !CONFIG_DEBUG_SLAB &&
 CONFIG_TRACING
References: <alpine.DEB.2.00.1004090947030.10992@chino.kir.corp.google.com> <1277891842-18898-1-git-send-email-dfeng@redhat.com> <alpine.DEB.2.00.1006301307001.27676@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1006301307001.27676@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Wed, 30 Jun 2010, Xiaotian Feng wrote:
> 
>> In slab, all __xxx_track_caller is defined on CONFIG_DEBUG_SLAB || CONFIG_TRACING,
>> thus caller tracking function should be worked for CONFIG_TRACING. But if
>> CONFIG_DEBUG_SLAB is not set, include/linux/slab.h will define xxx_track_caller to
>> __xxx() without consideration of CONFIG_TRACING. This will break the caller tracking
>> behaviour then.
>>
>> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
>> Cc: Christoph Lameter <cl@linux-foundation.org>
>> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>> Cc: Matt Mackall <mpm@selenic.com>
>> Cc: Vegard Nossum <vegard.nossum@gmail.com>
>> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: David Rientjes <rientjes@google.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Applied, thanks!
