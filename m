Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1FENMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 09:12:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44259 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1FENMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 09:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PsIUJJOk0E4ly9dg5I2Po/myq/zfcUJxKwy6kAlZ957mvUq5LRF4qB4JWXHrBRHwaK
         raLISP/uKUXwdaPpB8hqDksOjEnOLYNaCtWRE5GKq7NGX7MSvkCvsqCPEOFS1RLBfcIx
         6ocPv8QiJuliWfkpODjiDIX2mYTdLq/yDFzNw=
MIME-Version: 1.0
In-Reply-To: <20110605075458.GA2712@tarshish>
References: <20110605071725.26517.11573.stgit@ponder>
	<BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
	<20110605075458.GA2712@tarshish>
Date: Sun, 5 Jun 2011 18:42:45 +0530
Message-ID: <BANLkTi=K-kP4wFd2PP3JkPVs9FEm1ebCBw@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baruch,

On Sun, Jun 5, 2011 at 1:24 PM, Baruch Siach <baruch@tkos.co.il> wrote:
>> Though the spi_ prefix seems redundant considering the files are in
>> 'spi' directory.
>> Just a thought, no objection.
>
> When looking at the list of loaded modules (e.g. in an Oops message), the name
> "spi_xilinx" is much more meaningful than just "xilinx", for example.
Good catch.
Perhaps we could get Makefile to build modules with spi_ prefix. Just
like USB gadgets do ?
