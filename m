Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1KPHQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:16:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab1KPHQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:16:32 -0500
Message-ID: <4EC3633D.6090900@redhat.com>
Date: Wed, 16 Nov 2011 15:16:13 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        kay.sievers@vrfy.org
Subject: Re: [Patch] tmpfs: add fallocate support
References: <1321346525-10187-1-git-send-email-amwang@redhat.com> <CAOJsxLEXbWbEhqX2YfzcQhyLJrY0H2ifCJCvGkoFHZsYAZEMPA@mail.gmail.com> <4EC361C0.7040309@redhat.com> <alpine.LFD.2.02.1111160911320.2446@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111160911320.2446@tux.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月16日 15:12, Pekka Enberg 写道:
> On Wed, 16 Nov 2011, Cong Wang wrote:
>>> What's the use case for this?
>>
>> Systemd needs it, see http://lkml.org/lkml/2011/10/20/275.
>> I am adding Kay into Cc.
>
> The post doesn't mention why it needs it, though.
>

Right, I should mention this in the changelog. :-/
