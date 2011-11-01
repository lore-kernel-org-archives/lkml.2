Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1KALcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 07:32:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:31888 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1KALcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 07:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,437,1315206000"; 
   d="scan'208";a="84765113"
Date: Tue, 1 Nov 2011 11:42:42 +0000
From: Alan Cox <alan@linux.intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Baruch Siach <baruch@tkos.co.il>, torvalds@linux-foundation.org,
        Rong Wang <Rong.Wang@csr.com>, Bin Shi <Bin.Shi@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, linux-serial@vger.kernel.org,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] UART: add CSR SiRFprimaII SoC on-chip uart drivers
Message-ID: <20111101114242.7c90f958@bob.linux.org.uk>
In-Reply-To: <CAGsJ_4z=VtU+RJ4c0Y2ruttWU6mTVtHMxzvCYWGz=5w6i7QJMQ@mail.gmail.com>
References: <1319772453-1275-1-git-send-email-Barry.Song@csr.com>
	<20111028071129.GA2362@tarshish>
	<CAGsJ_4z=VtU+RJ4c0Y2ruttWU6mTVtHMxzvCYWGz=5w6i7QJMQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i am not sure whether i will make Linus confused if i send a new
> version at this moment. how about i send a seperate patch to fix this
> after the driver is applied?

That would be the best idea - its a trivial typo so doesn't really
matter much.
