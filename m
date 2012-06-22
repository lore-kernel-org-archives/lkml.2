Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765Ab2FVXR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:17:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62232 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2FVXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:17:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6750"; a="203881960"
X-IronPort-AV: E=Sophos;i="4.77,460,1336374000"; 
   d="scan'208";a="276272330"
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20452.64701.760819.559191@gargle.gargle.HOWL>
Date: Sat, 23 Jun 2012 04:46:13 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: pull request: wireless 2012-06-22
In-Reply-To: <20120622201716.GB13918@tuxdriver.com>
References: <20120622201716.GB13918@tuxdriver.com>
X-Mailer: VM 8.2.0b under 24.1.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> Mohammed Shafi Shajakhan (1):
>       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc

Um, this commit doesn't really fix anything - the timeout is also
arbitrary. Can you remove this from the 3.5 queue ? Thanks.

Sujith
