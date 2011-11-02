Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1KBFw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 01:52:57 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29278 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428Ab1KBFw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 01:52:56 -0400
Message-ID: <4EB0DAB6.7000106@dsn.lapis-semi.com>
Date: Wed, 02 Nov 2011 14:52:54 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/2] pch_uart: Delete modem status interrupt enable code
References: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>	<1319697919-5623-2-git-send-email-tomoya-linux@dsn.lapis-semi.com> <20111101125757.4ef7f883@bob.linux.org.uk>
In-Reply-To: <20111101125757.4ef7f883@bob.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/01 21:57), Alan Cox wrote:
>> (pch_uart device has auto hardware flow control function. So,
>> pch_uart driver doesn't have to control modem status interrupt.)
>
> This is true for flow control bits but not for incoming carrier detect ?

Called ".get_mctrl" function, other software can know incoming carrier 
detection.
Or you mean a uart driver must detect incoming carrier with interrupt ?

>> This patch deletes the code.
>
>> +	dev_info(priv->port.dev,
>> +		"PCH UART : Modem status interrupt is not
>> supported.\n"); }
>
> dev_info seems wrong here. Does the user need to know this ?
OK, a user doesn't have to know the information.
I will delete the dev_info.

Thanks,
-- 
tomoya
ROHM Co., Ltd.
