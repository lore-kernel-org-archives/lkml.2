Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab2HWCwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:52:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62215 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2HWCwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:52:03 -0400
Date: Wed, 22 Aug 2012 19:49:14 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: Renata Sayakhova <renata@oktetlabs.ru>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ds2781_battery: convert to module_platform_driver
Message-ID: <20120823024914.GF24471@lizard>
References: <1343645050-14982-1-git-send-email-develkernel412222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343645050-14982-1-git-send-email-develkernel412222@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:29:10PM +0545, Devendra Naga wrote:
> module_platform_driver can be used to replace the
> platform_driver register and unregister functions,
> with the calls to module_init and module_exit,
> 
> i.e. all the code that is doing like the below
> 
> static int __init mymod_init(void)
> {
> 	return platform_driver_register(&drv_operations);
> }
> 
> static void __exit mymod_exit(void)
> {
> 	platform_driver_unregister(&drv_operations);
> }
> 
> module_init(mymod_init);
> module_exit(mymod_exit);
> 
> can be replaced with
> module_platform_driver(drv_operations)...
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>

Nice! Both patches applied, thank you!
