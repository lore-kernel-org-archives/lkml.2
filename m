Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1G0U0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:26:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab1G0U0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107252025070.3090@tiger>
References: <alpine.DEB.2.00.1107252025070.3090@tiger>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jul 2011 13:26:00 -0700
Message-ID: <CA+55aFwgiE629MhByBaV0yWCceVbeVeej22VfSq0z6zhFp9iWw@mail.gmail.com>
Subject: Re: [GIT PULL v2] Native Linux KVM tool for v3.1
To: Pekka Enberg <penberg@kernel.org>
Cc: mingo@elte.hu, avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:27 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> Here's the same pull request with a small fixlet for a compile-time problem
> reported by Ingo Molnar.

Ok, having thought this over, I'm going to skip the KVM tool merge
this merge window. You'll need to convince me it's really worthwhile,
considering that you *can* do kernel testing with existing
virtualization environments that are more powerful in other ways. But
you'll get to do that next merge window, I'm afraid.

I already decided to pull one controversial thing (the iscsi-target
thing), I'm not doing two this merge window ;)

             Linus
