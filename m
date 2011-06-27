Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1F0XxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:53:16 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6264 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab1F0Xvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:51:44 -0400
Message-ID: <4E09178E.604@cavium.com>
Date: Mon, 27 Jun 2011 16:51:42 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/7] serial/8250: move UPIO_TSI to powerpc
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <1309211120-2803-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1309211120-2803-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2011 23:51:42.0603 (UTC) FILETIME=[2A437DB0:01CC3525]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 02:45 PM, Arnd Bergmann wrote:
> This iotype is only used by the legacy_serial code in powerpc, so the
> code should live there, rather than be compiled in for every 8250
> driver.
>
> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> Cc: linux-serial@vger.kernel.org
> ---
>   arch/powerpc/kernel/legacy_serial.c |   24 ++++++++++++++++++++++++
>   drivers/tty/serial/8250.c           |   23 -----------------------
>   2 files changed, 24 insertions(+), 23 deletions(-)
>

This seems vaguely familiar:

https://lkml.org/lkml/2008/10/6/297

So just for the hell of it...

Acked-by: David Daney <david.daney@cavium.com>

