Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2G0OrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:47:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59690 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2G0OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <1343150934.42443.YahooMailNeo@web120104.mail.ne1.yahoo.com>
References: <1342922751.65328.YahooMailNeo@web120106.mail.ne1.yahoo.com>
	<CAJd=RBC24UXztNoKews5sE06DRvk_cBEYunHT7Zc-rdvAFF0ew@mail.gmail.com>
	<1343150934.42443.YahooMailNeo@web120104.mail.ne1.yahoo.com>
Date: Fri, 27 Jul 2012 22:47:13 +0800
Message-ID: <CAJd=RBCy+zy6jRWkpjPx43H=jqs37-L8Qij4Z5y9DYak2L643w@mail.gmail.com>
Subject: Re: Direct I/O bug in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Victor Meyerson <calculuspenguin@yahoo.com>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 1:28 AM, Victor Meyerson
<calculuspenguin@yahoo.com> wrote:
>
> Still different checksums and I used the same random-file from my first test.
>
Then try the fix at
             https://lkml.org/lkml/2012/7/27/54

Good Weekend
Hillf
