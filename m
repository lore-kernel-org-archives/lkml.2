Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0D1NXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0D1NXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:23:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de>
To: Peter Fritzsche <peter.fritzsche@gmx.de>
Cc: dhowells@redhat.com, Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Ingo Molnar <mingo@elte.hu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>
Subject: Re: [PATCH 1/2] mn10300: Don't warn that atomic_t is only 24 bit
Date: Wed, 28 Apr 2010 14:22:15 +0100
Message-ID: <12704.1272460935@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Fritzsche <peter.fritzsche@gmx.de> wrote:

> 32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type.
> This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
> implementation to use the parisc approach of having an array of
> spinlocks to protect the atomic_t.
> 
> These warnings were also removed from the sparc implementation when the
> new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw,
> but the warning still remained in some other places without any
> 24-bit-only atomic_t implementation inside the kernel.
> 
> We should remove these warnings to allow users to rely on the full
> 32-bit range of atomic_t.
> 
> Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>

Acked-by: David Howells <dhowells@redhat.com>
