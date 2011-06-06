Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1FFQxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:53:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50746 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1FFQxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <4DED0510.1030600@gmail.com>
References: <20110606071829.10334.90865.stgit@ponder> <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
 <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com> <4DED0510.1030600@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 10:52:46 -0600
X-Google-Sender-Auth: KThUSdlhFlwLGdB6DdCdR5OdYiA
Message-ID: <BANLkTi=s2pnANPS5ZhjM9ZW8Bctk2v3DLw@mail.gmail.com>
Subject: Re: [PATCH v2] spi: reorganize drivers
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 10:49 AM, Dirk Brandewie
<dirk.brandewie@gmail.com> wrote:
> On 06/06/2011 09:38 AM, Grant Likely wrote:
>>
>> On Mon, Jun 6, 2011 at 10:31 AM, Mike Frysinger<vapier.adi@gmail.com>
>>  wrote:
>>>
>>> On Mon, Jun 6, 2011 at 03:18, Grant Likely wrote:
>>>>
>>>> Sort the SPI makefile and enforce the naming convention spi_*.c for
>>>> spi drivers.
>>>
>>> spi_topcliff_pch.c uses KBUILD_MODNAME with a few funcs, but perhaps
>>> those are only for /proc/ status tracking ?  worth double checking ...
>>
>> I just talked with Dirk Brandewie, who has a major rewrite to the
>> topcliff spi driver.  I'll let him comment on whether or not changing
>> KBUILD_MODNAME will cause any problems.
>>
>
> My changes are to the designware driver :-) I will get my patches re-based
> onto the spi-next branch and see if there any issues.

Hahaha.  Oops, I can't remember the conversation I had 5 minutes after
getting off the phone.

It should actually be Tomoya who can comment on the name change.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
