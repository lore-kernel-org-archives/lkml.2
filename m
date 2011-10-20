Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1JTUeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:34:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48768 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1JTUeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <6349D7A510622448B1BA0967850A8438011CC2A0@nasanexd02d.na.qualcomm.com>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
 <20111020.044541.970282389722164761.davem@davemloft.net> <6349D7A510622448B1BA0967850A8438011CC21D@nasanexd02d.na.qualcomm.com>
 <20111020.052506.373437241768777548.davem@davemloft.net> <6349D7A510622448B1BA0967850A8438011CC2A0@nasanexd02d.na.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 20 Oct 2011 13:33:57 -0700
X-Google-Sender-Auth: xJWiyE2sICOu7Hs47XPgdwcuJGA
Message-ID: <CAB=NE6W6Gc+dN3SzX00VwO9iheemNzhRQ34KuvMtZsBqVJQhJQ@mail.gmail.com>
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161 Ethernet driver
To: "Ren, Cloud" <cjren@qca.qualcomm.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 2:48 AM, Ren, Cloud <cjren@qca.qualcomm.com> wrote:
>
>>From: "Ren, Cloud" <cjren@qca.qualcomm.com>
>>Date: Thu, 20 Oct 2011 09:23:07 +0000
>>
>>> As you saw, should I do the two following steps?
>>> 1. I firstly try to submit code to linux-staging.git.
>>> 2. After the driver have been accepted by  linux-staging.git, I submit to net-
>>next.git again.
>>
>>You submit and get it into staging so that it can sit there for some time and get
>>reviewed and improved by others.
>>
>>One doesn't submit directly to net-next right after it gets into staging, staging
>>is a place where your driver lives while it still smelly funky and needs more
>>work.
>
> The driver will support the next generation NICs of Atheros. Meanwhile, the driver can
> also have better optimization for AR8131 and AR8151 than atl1c. For some reason, we
> don't plan to patch atl1c driver to support our new NIC, such as AR8161. So I hope the driver
> can stay in net-next in the end. Of course, I will be responsible for modify source code and
> let it match kernel requirements.

Cloud,

If you want to skip staging (which I recommend) then you need to
address all upstream concerns expressed. Given that you indicate that
you will be working on following up with the driver until its
acceptable upstream my recommendation is either to clean up the driver
very well and review it internally at Atheros prior to a public
submission *or* just dump into staging and get the benefit of
community cleanup and eventually wait until it is ready for proper
upstream. If you want internal private review at Atheros you can use
the internal private ath9k-devel list.

Also are you going to maintain the older atlx drivers? While at it can
you clear up who maintains what as far as Atheros is concerned for
Ethernet?

  Luis
