Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1FEU6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:58:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48906 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1FEU6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=K-kP4wFd2PP3JkPVs9FEm1ebCBw@mail.gmail.com>
References: <20110605071725.26517.11573.stgit@ponder> <BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
 <20110605075458.GA2712@tarshish> <BANLkTi=K-kP4wFd2PP3JkPVs9FEm1ebCBw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 5 Jun 2011 14:57:48 -0600
X-Google-Sender-Auth: IZ5xT3BEDhDabtckRMjmFH_DCGI
Message-ID: <BANLkTimnqZzwMAH8nqr2hN55Lcmiznr6+Q@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Baruch Siach <baruch@tkos.co.il>, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 7:12 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> Hi Baruch,
>
> On Sun, Jun 5, 2011 at 1:24 PM, Baruch Siach <baruch@tkos.co.il> wrote:
>>> Though the spi_ prefix seems redundant considering the files are in
>>> 'spi' directory.
>>> Just a thought, no objection.
>>
>> When looking at the list of loaded modules (e.g. in an Oops message), the name
>> "spi_xilinx" is much more meaningful than just "xilinx", for example.
> Good catch.
> Perhaps we could get Makefile to build modules with spi_ prefix. Just
> like USB gadgets do ?

I don't think it's worth mucking about with <module_name>-y :=
filename.o when the filename can just be made the same as the module
name.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
