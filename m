Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0KIRRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:17:01 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45491 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0KIRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:17:00 -0500
Date: Tue, 9 Nov 2010 09:16:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Lutolf <david@lutolf.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: duplicate symbol
Message-Id: <20101109091646.bda98776.randy.dunlap@oracle.com>
In-Reply-To: <1289295651-995eb1fafe32ac083b721f6ec0720266@lutolf.ch>
References: <1289295651-995eb1fafe32ac083b721f6ec0720266@lutolf.ch>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 10:40:51 +0100 David Lutolf wrote:

> in the kernel config, we can find
> 
> CS5535_GPIO (Device drivers -> Character devices)
> GPIO_CS5535 (Device drivers -> GPIO support)
> 
> this looks like it should be cleaned out

Well, it's unfortunate, undesirable, and confusing, but not incorrect AFAICT.

drivers/char/Kconfig:

config CS5535_GPIO
	tristate "AMD CS5535/CS5536 GPIO (Geode Companion Device)"

drivers/gpio/Kconfig:

config GPIO_CS5535
	tristate "AMD CS5535/CS5536 GPIO support"
	depends on PCI && !CS5535_GPIO


Still, I agree that a change would be good/helpful.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
