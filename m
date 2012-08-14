Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2HNXAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:00:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47460 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2HNXAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Wad1yNhUrvJZn0p62gZHAhpTjYaf5qNjjkdOboOiQ=Xg@mail.gmail.com>
References: <CAB=NE6W_SQUJmAXaLesyRShtQ=Urz=w5Ks5jEXq_50bRge+PWQ@mail.gmail.com>
 <CA+icZUU9qT9H2jy_H8_6Bk1XUbuV0N6_pGRoQbSJhnikewTc0Q@mail.gmail.com>
 <CAB=NE6V=4J7yKbPdb4gVT6BBjdewhYRNEwrNdMd4XE5Ocg4SeQ@mail.gmail.com> <CAB=NE6Wad1yNhUrvJZn0p62gZHAhpTjYaf5qNjjkdOboOiQ=Xg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 14 Aug 2012 16:00:17 -0700
X-Google-Sender-Auth: FqEKPUlRxenDtVO6eLxrfkTCDJI
Message-ID: <CAB=NE6UztqzdJ20GV+bV3jZ-083h8NgX-+AXsyFYJ--V93_=_g@mail.gmail.com>
Subject: Re: Backports mailing list
To: sedat.dilek@gmail.com
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        lf_driver_backport@lists.linux-foundation.org,
        Julia Lawall <julia.lawall@lip6.fr>, Jesper Andersen <jespera@diku.dk>,
        =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 9:33 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Tue, Aug 14, 2012 at 9:00 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>> For more details please see:
>>
>> http://www.do-not-panic.com/2012/08/automatically-backporting-linux-kernel.html
>> http://www.do-not-panic.com/2012/08/optimizing-backporting-collateral.html
>>
>>   Luis
>
> All that said, please use the shiny new mailing list:
> backports@vger.kernel.org  for  patches for compat / compat-drivers.

Furthermore, the project git tree has changed to be renamed to
compat-drivers as well now, and the new wiki page should be used
moving forward:

https://backports.wiki.kernel.org
git://github.com/mcgrof/compat-drivers.git

  Luis
