Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2IJD4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:56:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2IJD4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:56:38 -0400
Message-ID: <504D64F1.206@lwfinger.net>
Date: Sun, 09 Sep 2012 22:56:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: Question about failure in PCI power-state change
References: <504A78E9.4030005@lwfinger.net>  <CAErSpo7GEkN1XLZ=UeXmDZrLnp_648mH-sLYa9hMgOqz7t+b7Q@mail.gmail.com> <1347236699.28607.17.camel@yhuang-dev>
In-Reply-To: <1347236699.28607.17.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 07:24 PM, Huang Ying wrote:
> On Fri, 2012-09-07 at 15:48 -0700, Bjorn Helgaas wrote:
>> +cc Rafael, Huang, linux-pm
>>
>> On Fri, Sep 7, 2012 at 3:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> Hi,
>>>
>>> On occasion when I unload and reload driver rtl8192ce, I get the message
>>>
>>> "Refused to change power state, currently in D3"
>
> Hi, Larry,
>
> We fixed a similar issue recently.  And the patch has been merged by
> v3.6-rc5.  Can you try v3.6-rc5?

V3.6-rc5 was merged with wireless-testing today. It did not change my symptoms, 
but I think I have identified another problem with my driver.

Thanks for the heads-up.

Larry


