Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab1CaNvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:51:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44373 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab1CaNvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:51:50 -0400
Date: Thu, 31 Mar 2011 14:51:26 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Arend van Spriel <arend@broadcom.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        devel@linuxdriverproject.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
	in separate module
Message-ID: <20110331135126.GC19540@flint.arm.linux.org.uk>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz> <201103301453.48607.arnd@arndb.de> <4D948624.3040605@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D948624.3040605@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 03:48:20PM +0200, Jiri Slaby wrote:
> How it can? Packed only tells the compiler to have one byte alignment
> steps. And it should not matter here as all the members are 32-bit long.

It also tells the compiler that it may be misaligned, so to avoid
alignment faults it will use byte loads/stores.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
