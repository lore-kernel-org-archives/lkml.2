Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2ATRis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:38:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51529 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2ATRiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120120173604.GD3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <CAO+b5-rwSy9_7LmbNBKQPmYU8M5z48WRCV3tRSjeUnswPkT+Kw@mail.gmail.com>
	<20120120173604.GD3336@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Fri, 20 Jan 2012 17:38:45 +0000
X-Google-Sender-Auth: YUHzMh_n-WyfWP32DXw6HKP4VHo
Message-ID: <CAO+b5-r=e_7ereoWbV2bMh+nApk2zeE9=yk=2eGQRhhZZsJVPw@mail.gmail.com>
Subject: Re: AHCI_SHT(), ATA_BASE_SHT() and .can_queue
From: Bart Van Assche <bvanassche@acm.org>
To: Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 5:36 PM, Tejun Heo <htejun@gmail.com> wrote:
> On Sat, Jan 14, 2012 at 05:04:21PM +0000, Bart Van Assche wrote:
>> I guess the fact that can_queue is specified twice and with different
>> values in AHCI_SHT() was unintentional ?
>
> Yes, it is intentional.  The macros provide default values which
> specific drivers or downstream class of drivers may choose to
> override.

Unfortunately sparse complains about that construct. It is annoying
when checking e.g. drivers/scsi with sparse to see sparse complain
many times about two different values being specified for .can_queue.
Should the sparse authors remove that warning ?

Bart.
