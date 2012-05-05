Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2EECvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 22:51:14 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:43337 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab2EECvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 22:51:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLQEBBCNVARALGgIFFgsCAgkDAgECAUUGDQEHAQG0JIoYgS+OE4EYBKkl
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="178434783"
Message-ID: <4FA4959F.2000905@teksavvy.com>
Date: Fri, 04 May 2012 22:51:11 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chris Jones <chrisjones@spin.net.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hard drive detection
References: <20120504185604.3addfd2e@ubuntu> <4FA3D60F.9090601@teksavvy.com> <20120505093000.1d9789dd@ubuntu>
In-Reply-To: <20120505093000.1d9789dd@ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-04 07:30 PM, Chris Jones wrote:
..
> Thanks Mark. That's exactly what I was looking for. And are both PATA
> and SATA internal drives both located in drivers/ata?
..

Yes.
But historically, PATA drives were handled by the original IDE drivers
that I worked on in the mid-1990s.  That code is in linux/drivers/ide,
but we're trying hard to phase it out.  The code in linux/drivers/ata
(aka. "libata") handles nearly all of the same PATA stuff and more.

Cheers
