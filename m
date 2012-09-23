Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab2IWLug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 07:50:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab2IWLuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 07:50:35 -0400
Message-ID: <505EF784.7060504@redhat.com>
Date: Sun, 23 Sep 2012 13:50:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11] kvm: Add resampling irqfds for level triggered interrupts
References: <20120921175601.32604.63271.stgit@bling.home>
In-Reply-To: <20120921175601.32604.63271.stgit@bling.home>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 08:58 PM, Alex Williamson wrote:
> To emulate level triggered interrupts, add a resample option to
> KVM_IRQFD.  When specified, a new resamplefd is provided that notifies
> the user when the irqchip has been resampled by the VM.  This may, for
> instance, indicate an EOI.  Also in this mode, posting of an interrupt
> through an irqfd only asserts the interrupt.  On resampling, the
> interrupt is automatically de-asserted prior to user notification.
> This enables level triggered interrupts to be posted and re-enabled
> from vfio with no userspace intervention.
>
> All resampling irqfds can make use of a single irq source ID, so we
> reserve a new one for this interface.
>

Thanks, applied.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

