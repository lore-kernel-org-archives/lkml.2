Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2BQEhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:37:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35973 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2BQEhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <1329412171-20704-3-git-send-email-danny.kukawka@bisect.de>
References: <1329412171-20704-1-git-send-email-danny.kukawka@bisect.de> <1329412171-20704-3-git-send-email-danny.kukawka@bisect.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 16 Feb 2012 23:37:25 -0500
X-Google-Sender-Auth: dDoo8o7KRWvEXRE6CuBtPBXuyDc
Message-ID: <CAMjpGUdAe66Nw16EyM1_dv4e8uHV02tcfqiuWL8ipeUrQ=HThg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] adi: adapt to eth_hw_addr_random() and changes in arch/blackfin
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bob Liu <bob.liu@analog.com>, uclinux-dist-devel@blackfin.uclinux.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 12:09, Danny Kukawka wrote:
> +                       netdev_warn(ndev, "Setting Ethernet MAC to a random one\n");
> +                       eth_hw_addr_random(ndev);

would it make sense to have the core dump the warning ?
-mike
