Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2CTKGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:06:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63460 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2CTKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:06:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6654"; a="173980313"
X-IronPort-AV: E=Sophos;i="4.73,616,1325491200"; 
   d="scan'208";a="177564896"
Message-ID: <4F685690.5020102@qca.qualcomm.com>
Date: Tue, 20 Mar 2012 12:06:08 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next 3/3] ath6kl: Add __printf verification to
 ath6kl_printk
References: <cover.1332116921.git.joe@perches.com> <a27a7b0fcddc2f2366ff5ab0968ca0ff78d420c5.1332116921.git.joe@perches.com>
In-Reply-To: <a27a7b0fcddc2f2366ff5ab0968ca0ff78d420c5.1332116921.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 02:30 AM, Joe Perches wrote:
> Make sure printf formats and arguments match.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, I have applied this to ath6kl.git. John, I hope this is ok for you.

Kalle
