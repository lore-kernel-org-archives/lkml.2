Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2LSEJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:09:31 -0500
Received: from intranet.asianux.com ([58.214.24.6]:38312 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LSEJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:09:24 -0500
X-Spam-Score: -100.8
Message-ID: <50D13E28.40105@asianux.com>
Date: Wed, 19 Dec 2012 12:10:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] synclink fix ldisc buffer argument
References: <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <20121202151332.3b6a6504@pyramind.ukuu.org.uk> <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com> <20121202181057.097012c6@pyramind.ukuu.org.uk> <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com> <50BC0C84.4060802@asianux.com> <50BCCD4C.8050209@microgate.com> <50BEAA0E.9000603@asianux.com> <50D12521.8010808@asianux.com> <20121219040907.GA22719@kroah.com>
In-Reply-To: <20121219040907.GA22719@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月19日 12:09, Greg KH 写道:
> On Wed, Dec 19, 2012 at 10:23:29AM +0800, Chen Gang wrote:
>> Hello Paul Fulghum:
>>
>> it seems you are very busy,
>>   and can not get your reply for "checking length in function rx_get_buf".
> 
> You should always send patches, long emails like this about "potential"
> issues are hard to handle, patches are best.
> 
> greg k-h
> 
> 

  ok, I will send patch after unit test.


-- 
Chen Gang

Asianux Corporation
