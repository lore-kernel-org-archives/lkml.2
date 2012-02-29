Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2B2Ji1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:38:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2B2JiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:38:25 -0500
MIME-Version: 1.0
In-Reply-To: <157393863283F442885425D2C454285619415703@nasanexd02a.na.qualcomm.com>
References: <157393863283F442885425D2C4542856194154FC@nasanexd02a.na.qualcomm.com>
 <20120228.212857.797446903975232476.davem@davemloft.net> <157393863283F442885425D2C454285619415561@nasanexd02a.na.qualcomm.com>
 <20120228.223258.2261979237568571219.davem@davemloft.net> <157393863283F442885425D2C454285619415703@nasanexd02a.na.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 29 Feb 2012 01:38:03 -0800
X-Google-Sender-Auth: TcYuhhJ1D_ghlsPc_9OZpUAF-3Y
Message-ID: <CAB=NE6Us9THvXDLvkxiuridOD1ry60pLyzQsWBronBHCUNV3Vg@mail.gmail.com>
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
To: "Huang, Xiong" <xiong@qca.qualcomm.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Giori, Kathy" <kgiori@qca.qualcomm.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:30 PM, Huang, Xiong <xiong@qca.qualcomm.com> wrote:
> My another concern is the license type. Current atl1c use GPL v2, and got some contribution outside of QCA though the first version
> was wrote by our Atheros guy. And that guy just copied the license from atl1e/atl1x that contains the words "Derived from Intel e1000".
>
> If I update this driver and add new chip support on it, Our Company's legal might not permit me to do so, they prefer QCA ISC license.
> Is it possible to change the license header to ISC while I applying patches to source code ?

No.

  Luis
