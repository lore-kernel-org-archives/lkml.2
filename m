Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1GOHmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 03:42:04 -0400
Received: from lucidpixels.com ([72.73.18.11]:49417 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1GOHmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 03:42:03 -0400
Date: Fri, 15 Jul 2011 03:42:01 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39.2: discard not supported on mpt2sas
In-Reply-To: <alpine.DEB.2.02.1107141752580.4904@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1107150341350.17582@p34.internal.lan>
References: <alpine.DEB.2.02.1107141752580.4904@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 14 Jul 2011, Justin Piszcz wrote:

> Hi,
>
> Something interesting to note:
>
> When I have an Intel 510 SSD plugged into an mpt2sas board, discard (TRIM) is 
> not supported:
>
> [   16.483409] EXT4-fs (sda2): re-mounted. Opts: discard
> [   17.814743] EXT4-fs warning (device sda2): release_blocks_on_commit:2679: 
> discard not supported, disabling
>
> With a regular SATA port or an (PCI-e 2.0 x1 card), it works but with the 
> overhead, PCI-e x1 seems to peak around 400-430MiB/s for reads, whereas with 
> an X8 SAS controller I see 480-495MiB/s as the benchmarks show on various 
> websites, ah well, its one thing or the other.
>
> Justin.
>

Hi,

Is there anyway to allow pass through for TRIM via mp2sas or is it 
strictly for SATA controllers only?

Justin.


