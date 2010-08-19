Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0HSNMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:12:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:41944 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751686Ab0HSNML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:12:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABHKbExLd/sX/2dsb2JhbAAHgxHId5IcgSKDInME
X-IronPort-AV: E=Sophos;i="4.56,233,1280721600"; 
   d="scan'208";a="72985792"
Message-ID: <4C6D2DA7.9030803@teksavvy.com>
Date: Thu, 19 Aug 2010 09:12:07 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: tj@kernel.org, jeff@garzik.org, ben.collins@ubuntu.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        hmh@debian.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W449B3ACDB36B8BF9EBE145C3A40@phx.gbl>
In-Reply-To: <SNT125-W449B3ACDB36B8BF9EBE145C3A40@phx.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-07-24 02:48 PM, Yuhong Bao wrote:
>
> In fact, Seagate is already selling 3TB external drives and CrunchGear
> was already able to get the internal 3TB drive inside out:
> http://techcrunch.com/2010/07/01/hands-on-the-seagate-freeagent-goflex-desk-3tb-external-hard-drive/


The key word there is _external_ --> by using USB3/2/FW interfaces,
they neatly sidestep most BIOS issues.  For the time being anyway.

