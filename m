Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2FWGMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:12:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62891 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2FWGMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:12:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6750"; a="203933035"
X-IronPort-AV: E=Sophos;i="4.77,462,1336374000"; 
   d="scan'208";a="121480760"
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20453.24023.191664.676844@gargle.gargle.HOWL>
Date: Sat, 23 Jun 2012 11:40:31 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: pull request: wireless 2012-06-22
In-Reply-To: <20120623041103.GA29801@tuxdriver.com>
References: <20120622201716.GB13918@tuxdriver.com>
	<20452.64701.760819.559191@gargle.gargle.HOWL>
	<20453.302.671438.533390@gargle.gargle.HOWL>
	<20120622.165611.2220193371527786713.davem@davemloft.net>
	<20453.9687.225096.194368@gargle.gargle.HOWL>
	<20120623041103.GA29801@tuxdriver.com>
X-Mailer: VM 8.2.0b under 24.1.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> > The patch was under review:
> > http://marc.info/?l=linux-wireless&m=134001371002288&w=2
> 
> Quibbling over the exact number of iterations for a timeout didn't
> seem is important as avoiding an endless loop...

Yes, which is why I okayed the patch. :)

Sujith
