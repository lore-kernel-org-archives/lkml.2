Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2EDNNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:13:54 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:64028 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab2EDNNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:13:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQEDI1UBEAsYAgIFFgsCAgkDAgECAUUGDQEHAQG0JIoYgS+OE4EYBKkl
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="178323225"
Message-ID: <4FA3D60F.9090601@teksavvy.com>
Date: Fri, 04 May 2012 09:13:51 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chris Jones <chrisjones@spin.net.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hard drive detection
References: <20120504185604.3addfd2e@ubuntu>
In-Reply-To: <20120504185604.3addfd2e@ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-04 04:56 AM, Chris Jones wrote:
> What section of the kernel detects internal hard drives upon boot?

That depends upon how the drive is connected.
But generally speaking, the device driver for the drive-controller
will probe and find any attached drives.

So for modern kernels, on systems with SATA drives,
the code is in linux/drivers/ata/

Cheers
