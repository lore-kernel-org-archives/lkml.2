Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1KXGpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:45:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46414 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1KXGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:45:43 -0500
Date: Thu, 24 Nov 2011 08:45:35 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Kujau <lists@nerdbynature.de>, markus@trippelsdorf.de
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or
 corruption
In-Reply-To: <alpine.DEB.2.00.1111231428440.5261@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1111240842540.2385@tux.localdomain>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1111220855460.25785@router.home> <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1111231030370.14209@tux.localdomain>
 <alpine.DEB.2.00.1111230916220.16139@router.home> <1322083191.1428.125.camel@jaguar> <alpine.DEB.2.00.1111231428440.5261@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Pekka Enberg wrote:
>> Yes, you did. I'm just trying to figure out which ones are going
>> straight to Linus and which ones can wait for v3.3.

On Wed, 23 Nov 2011, David Rientjes wrote:
> I think it's 3.2-rc material since it can trigger a NULL pointer by
> reading a file from userspace, it's not limited only to debugging.

Applied, thanks!
