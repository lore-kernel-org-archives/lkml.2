Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1FFQtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:49:25 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42329 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1FFQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qlQGDtd+ZIAMy2Yh7PCtxK54LIJQRlijpWxlqlUm0JgLYzbDg77obTQ5XT/OqGqQul
         3vJW4S2WjY8yadbAmuV9kgebxgK6xK5VGhB6G1g76X3bIR2zl8Wlf8KZKk9jUolGO3r+
         NbTDMznGoj1tPL2VziPBCT47VC322cTvtswjQ=
Message-ID: <4DED0510.1030600@gmail.com>
Date: Mon, 06 Jun 2011 09:49:20 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Mike Frysinger <vapier.adi@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] spi: reorganize drivers
References: <20110606071829.10334.90865.stgit@ponder> <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com> <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com>
In-Reply-To: <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 09:38 AM, Grant Likely wrote:
> On Mon, Jun 6, 2011 at 10:31 AM, Mike Frysinger<vapier.adi@gmail.com>  wrote:
>> On Mon, Jun 6, 2011 at 03:18, Grant Likely wrote:
>>> Sort the SPI makefile and enforce the naming convention spi_*.c for
>>> spi drivers.
>>
>> spi_topcliff_pch.c uses KBUILD_MODNAME with a few funcs, but perhaps
>> those are only for /proc/ status tracking ?  worth double checking ...
>
> I just talked with Dirk Brandewie, who has a major rewrite to the
> topcliff spi driver.  I'll let him comment on whether or not changing
> KBUILD_MODNAME will cause any problems.
>

My changes are to the designware driver :-) I will get my patches re-based onto 
the spi-next branch and see if there any issues.

--Dirk
