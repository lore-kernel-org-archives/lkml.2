Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab2DKWnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:43:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51627 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2DKWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:43:20 -0400
Message-ID: <4F860905.4090106@gmail.com>
Date: Wed, 11 Apr 2012 15:43:17 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: almost time to run my kernel source cleaning scripts again?
References: <alpine.DEB.2.02.1204111700170.4733@oneiric>
In-Reply-To: <alpine.DEB.2.02.1204111700170.4733@oneiric>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 02:07 PM, Robert P. J. Day wrote:
>
>    it's been a while so i was thinking of firing up my scripts to
> peruse the source tree looking for oddities/inconsistencies/whatever
> (unless someone else is already doing that).
>
>    one example is looking for preprocessor tests of symbols that aren't
> defined in any Kconfig file, and i can focus on any part of the source
> tree.  for example, if i run that script against drivers/mmc, i get:
[...]
>
>>>>>> CAVIUM_OCTEON_NUM_PACKET_BUFFERS
> drivers/staging/octeon/ethernet-defines.h:36: *  CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
> drivers/staging/octeon/ethernet.c:56:#if defined(CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS) \
> drivers/staging/octeon/ethernet.c:57:	&&  CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
> drivers/staging/octeon/ethernet.c:58:int num_packet_buffers = CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS;

I am aware of these and am working on fixing them.

Thanks,
David Daney
