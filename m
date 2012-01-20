Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2ATRgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:36:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33122 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2ATRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:36:11 -0500
Date: Fri, 20 Jan 2012 09:36:04 -0800
From: Tejun Heo <htejun@gmail.com>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: AHCI_SHT(), ATA_BASE_SHT() and .can_queue
Message-ID: <20120120173604.GD3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <CAO+b5-rwSy9_7LmbNBKQPmYU8M5z48WRCV3tRSjeUnswPkT+Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+b5-rwSy9_7LmbNBKQPmYU8M5z48WRCV3tRSjeUnswPkT+Kw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 14, 2012 at 05:04:21PM +0000, Bart Van Assche wrote:
> I guess the fact that can_queue is specified twice and with different
> values in AHCI_SHT() was unintentional ?

Yes, it is intentional.  The macros provide default values which
specific drivers or downstream class of drivers may choose to
override.

Thanks.

-- 
tejun
