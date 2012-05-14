Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2ENQpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:45:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8053 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2ENQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:45:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 May 2012 09:44:53 -0700
Message-ID: <4FB135BB.2020001@nvidia.com>
Date: Mon, 14 May 2012 22:11:31 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Regmap cached only when write happen to register
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
When debugging  on register caching, found that register is getting 
cached only when write happen to the register otherwise it will not get 
cached even any number of read happen.
Is it by intended or there is opportunity to enhance it so that during 
read also we can cache it.\?

Thanks,
Laxman

