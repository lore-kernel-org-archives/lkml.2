Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1GTAOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:14:48 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:31344 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab1GTAOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:14:47 -0400
Message-ID: <4E261DF2.7070705@dsn.okisemi.com>
Date: Wed, 20 Jul 2011 09:14:42 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>
Subject: Re: serial/pch_uart: AT command behavior
References: <1308736219-19975-1-git-send-email-alexander.stein@systec-electronic.com>	<4E02857C.1010304@dsn.okisemi.com>	<4E2504FD.6090107@dsn.okisemi.com> <20110719100613.21b9eb32@lxorguk.ukuu.org.uk>
In-Reply-To: <20110719100613.21b9eb32@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/19 18:06), Alan Cox wrote:
> On Tue, 19 Jul 2011 13:15:57 +0900
> Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>  wrote:
>
>> Hi,
>>
>> I have a question for UART driver AT command behavior.
>> When installing pch_uart, AT command "AT+GCAP^M" are sent for 4 times.
>> This command is sent first install only.
>> (After the above, removing pch_uart and installing pch_uart again,
>> this command is not sent.)
>>
>> Let me know the behavior is normal or not ?
>
> As your distribution, it isn't the kernel.
>
Thank you for your information.
The above behavior looks Fedora's.
In fact,I confirmed MeeGo doesn't send any AT command message.

Thanks,

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
