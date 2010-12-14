Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0LNIyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:54:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab0LNIyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:54:06 -0500
Message-ID: <4D0730A3.4080706@redhat.com>
Date: Tue, 14 Dec 2010 10:53:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM & genirq: Enable adaptive IRQ sharing for
 passed-through devices
References: <cover.1292281184.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 12:59 AM, Jan Kiszka wrote:
> Final but critical question: Who will pick up which bits?
>

The procedure which has served us well in the past is that tip picks up 
the irq stuff and sticks them in a fast-forward-only branch; kvm merges 
the branch and applies the kvm bits on top.

-- 
error compiling committee.c: too many arguments to function

