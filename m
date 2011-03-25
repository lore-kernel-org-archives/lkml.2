Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1CYAIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:08:37 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:7521 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1CYAIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:08:35 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: <sedat.dilek@gmail.com>, "'linux-next'" <linux-next@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Randy Dunlap'" <randy.dunlap@oracle.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
References: <AANLkTik0tLsZCmcf8JNBtyePnKZzfoyA9SWH9k51+cc8@mail.gmail.com> <AANLkTi=gUTJs58mBkyLrvbtob=x=k6gD8-QR1HA61g+Q@mail.gmail.com>
Subject: RE: linux-next: Tree for March 24 (BUG: soft lockup - CPU#0 stuck for 63s! [kworker/0:1:7764])
Date: Fri, 25 Mar 2011 09:08:32 +0900
Message-ID: <641556B1566641C0A286D4F2F1383DAD@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <AANLkTi=gUTJs58mBkyLrvbtob=x=k6gD8-QR1HA61g+Q@mail.gmail.com>
Thread-Index: AcvqNX6ySUHMTUiKTE68rSL9/6iXAwASTM8g
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Sedat,

We have used this DMA driver(include this patch) on linux-2.6.35/37.
However I haven't seen the issue yet.

I want to know more information.
Do you mean that it takes 63 more seconds for boot-completing
when using this patch and pch_dma is integrated as built-in ? 

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Sedat Dilek [mailto:sedat.dilek@googlemail.com] 
> Sent: Friday, March 25, 2011 12:10 AM
> To: linux-next; LKML
> Cc: Stephen Rothwell; Randy Dunlap; Vinod Koul; Tomoya MORINAGA
> Subject: Re: linux-next: Tree for March 24 (BUG: soft lockup 
> - CPU#0 stuck for 63s! [kworker/0:1:7764])

