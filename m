Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1L1JjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:39:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1L1JjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:39:23 -0500
Date: Wed, 28 Dec 2011 01:42:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-Id: <20111228014250.51c2e60e.akpm@linux-foundation.org>
In-Reply-To: <20111228074214.GC27266@moon>
References: <20111223124741.711871189@openvz.org>
	<20111223124920.661126615@openvz.org>
	<20111227152344.c8c140d3.akpm@linux-foundation.org>
	<20111228074214.GC27266@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Dec 2011 11:42:14 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Maybe we could simply extend prctl then?

I'd suggest a syscall.  prctl is a big crap bucket and this thing has
simple, well defined semantics.  syscalls are cheap.

