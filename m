Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1KBNbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:31:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49191 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1KBNbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:31:06 -0400
MIME-Version: 1.0
Date: Wed, 2 Nov 2011 13:31:05 +0000
Message-ID: <CAFEAcA_hJK3fT-mvtJj9ZfQ2cGsv0Oy5vpbir=XfmP4HG+7o2g@mail.gmail.com>
Subject: Re: Additional virtio-mmio spec changes
From: Peter Maydell <peter.maydell@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty wrote:
>Pawel Moll <pawel.moll@arm.com> wrote:
>> Peter also mentioned that he didn't like the "Num" in
>> "QueueNum" register name and would rather see it called "QueueSize". I
>> have no strong opinions either way and can provide patches to both the
>> spec and the driver (and header) to change it. Any thoughts?
>
> Num isn't great, but Size might be misleading.  I'd leave it...

I'd note that calling it QueueNum  is inconsistent with the main
virtio spec, which calls the equivalent virtio header field
"Queue Size". Also if the docs say

"QueueNum
 Virtual queue size.
 Queue size is a number of elements in the queue [...]"

this rather suggests to me that we've picked the wrong name for
the register...

-- PMM
