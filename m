Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab0FJQd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:33:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab0FJQd4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <4C10B10D.80304@redhat.com>
References: <4C10B10D.80304@redhat.com>
Date: Thu, 10 Jun 2010 09:33:48 -0700
Message-ID: <AANLkTilIIesuFHNVBhpeOe3XiJ5JDDIxt2wLH9MzyF_e@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for 2.6.35-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 2:31 AM, Avi Kivity <avi@redhat.com> wrote:
> Linus, please pull from
>
>  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.35
>
> to receive a bunch of KVM fixes for 2.6.35-rc2, including a workaround for a
> cpu erratum that can allow a guest to crash the host.

Hmm. This looks bigger than I'd wish for at this point. I'll be
offline starting Saturday, so I want -rc3 (on Friday evening) to be in
as well-known a state as humanly possible. Which is why I've been
pushing back a lot on anything that isn't absolutely essential.

                    Linus
