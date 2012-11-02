Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab2KBESr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 00:18:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53883 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2KBESq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 00:18:46 -0400
Message-ID: <509349A4.3040709@wwwdotorg.org>
Date: Thu, 01 Nov 2012 22:18:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: linux-kernel@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>,
        Olof Johansson <olof@lixom.net>, linux-rpi-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] irqchip: irq-bcm2835: Add terminating entry for of_device_id
 table
References: <1351779418.11071.1.camel@phoenix>
In-Reply-To: <1351779418.11071.1.camel@phoenix>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 08:16 AM, Axel Lin wrote:
> The of_device_id table is supposed to be zero-terminated.

Thanks. How embarrassing! I forwarded this to arm-soc for inclusion into
3.7.
