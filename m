Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2DLFIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:08:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7913 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab2DLFIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:08:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6677"; a="180927733"
X-IronPort-AV: E=Sophos;i="4.75,409,1330934400"; 
   d="scan'208";a="302328437"
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20358.25376.230264.236893@gargle.gargle.HOWL>
Date: Thu, 12 Apr 2012 10:37:44 +0530
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Heinz Diehl <htd@fancy-poultry.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        "linux-wireless Mailing List" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Regression due to "ath9k: fix going to full-sleep on PS idle"
In-Reply-To: <CA+55aFxWD1bE0oiR4GpLP19MCm2CzwuApuYhcE_NF7bC+tFYjg@mail.gmail.com>
References: <CA+55aFxWD1bE0oiR4GpLP19MCm2CzwuApuYhcE_NF7bC+tFYjg@mail.gmail.com>
X-Mailer: VM 8.2.0a under 23.4.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> You guys need to fix the subject line (like this), and make sure that
> the right people are cc'd. This is not a "stable" issue - stable
> cannot revert stuff that hasn't been reverted upstream.
> 
> So instead of stable and Greg, it should be netdev and Davem.
> 
> David/John: multiple people are complaining about that commit. It
> really should be reverted, or a fix found. It's broken.
> 
> I can do the revert, but it would be better coming from the networking people.

John has already reverted the commit:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless.git;a=commit;h=011afa1ed8c408d694957d2474d89dc81a60b70c

Sujith
