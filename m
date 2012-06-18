Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2FRSbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:31:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41505 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2FRSbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:31:44 -0400
Date: Mon, 18 Jun 2012 20:31:41 +0200
From: Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: PROBLEM: New 3.5.0-rcx kernel hang after uncompressing the
 kernel image on Orion ARM machine linkstation pro
Message-ID: <20120618183141.GA12544@schnuecks.de>
References: <4FDF113E.4080505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDF113E.4080505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 07:30:06PM +0800, cloudy.linux wrote:
...
> at 3.5-RCx. Both RC2 and RC3 ends the same, the system never boot.
> The serial console shows that the kernel hangs after "Uncompressing
> Linux ... done, booting the kernel" message. I tried to enable some
...

Did you apply the fix for the printk alignment issue?

https://lkml.org/lkml/2012/6/17/52

- Simon

