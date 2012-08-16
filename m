Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2HPL7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:59:14 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64226 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540Ab2HPL7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:59:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120816113254.2950cf36@pixies.home.jungo.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
 <1345043331.3393.151.camel@sauron.fi.intel.com> <20120816113254.2950cf36@pixies.home.jungo.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 16 Aug 2012 13:58:51 +0200
Message-ID: <CACQ1gAg4D-MQZiZ20cbwB4k5Phf9cPJ+F75et+h_cZqEmwdPdg@mail.gmail.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get bad_peb_limit
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dedekind1@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/16 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> Hi,
>
> One more thing...
>
> On Wed, 15 Aug 2012 18:08:51 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
>>  config MTD_UBI_BEB_LIMIT
>> -     int "Percentage of maximum expected bad eraseblocks"
>> -     default 2
>> -     range 0 25
>> +     int "Maximum expected bad eraseblock count per 1024 eraseblocks"
>> +     default 20
>> +     range 2 256
>
> Those defconfigs that explicilty set an original LIMIT should be
> adjusted as well, as the units have changed, no?

you mean that it should be between 0 and 256 ?
