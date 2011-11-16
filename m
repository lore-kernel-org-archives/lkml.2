Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1KPHMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:12:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53831 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1KPHMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:12:16 -0500
Date: Wed, 16 Nov 2011 09:12:10 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        kay.sievers@vrfy.org
Subject: Re: [Patch] tmpfs: add fallocate support
In-Reply-To: <4EC361C0.7040309@redhat.com>
Message-ID: <alpine.LFD.2.02.1111160911320.2446@tux.localdomain>
References: <1321346525-10187-1-git-send-email-amwang@redhat.com> <CAOJsxLEXbWbEhqX2YfzcQhyLJrY0H2ifCJCvGkoFHZsYAZEMPA@mail.gmail.com> <4EC361C0.7040309@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Cong Wang wrote:
>> What's the use case for this?
>
> Systemd needs it, see http://lkml.org/lkml/2011/10/20/275.
> I am adding Kay into Cc.

The post doesn't mention why it needs it, though.

 			Pekka
