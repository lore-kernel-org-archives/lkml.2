Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2LCQid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:38:33 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:19207 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2LCQic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:38:32 -0500
Message-ID: <50BCD586.2060506@tilera.com>
Date: Mon, 3 Dec 2012 11:38:30 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <yongjun_wei@trendmicro.com.cn>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] tile/PCI: use for_each_pci_dev to simplify the
 code
References: <CAPgLHd-GK0ZO97vhaNhFuHBxuHf+s+7YQ1kw_-+7pUVoqNwgdw@mail.gmail.com>
In-Reply-To: <CAPgLHd-GK0ZO97vhaNhFuHBxuHf+s+7YQ1kw_-+7pUVoqNwgdw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/2012 8:28 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use for_each_pci_dev to simplify the code.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, I've taken this into my tree for -next.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

