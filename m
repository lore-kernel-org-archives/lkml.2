Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2FXM5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 08:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab2FXM5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 08:57:03 -0400
Message-ID: <4FE70E99.90609@redhat.com>
Date: Sun, 24 Jun 2012 15:56:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Subject: Re: [PATCH 4/4][RFC] kvm: eoi_eventfd
References: <20120622220040.9858.43665.stgit@bling.home> <20120622221626.9858.33817.stgit@bling.home>
In-Reply-To: <20120622221626.9858.33817.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 01:16 AM, Alex Williamson wrote:
> I think we're probably also going to need something like this.
> When running in non-accelerated qemu, we're going to have to
> create some kind of EOI notifier for drivers.  VFIO can make
> additional improvements when running on KVM so it will probably
> make use of the KVM_IRQFD_LEVEL_EOI interface, but we don't
> want to have a generic EOI notifier in qemu that just stops
> working when kvm-ioapic is enabled.

Why?



-- 
error compiling committee.c: too many arguments to function


