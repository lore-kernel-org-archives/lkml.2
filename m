Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab2LJBbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:31:33 -0500
Received: from intranet.asianux.com ([58.214.24.6]:17647 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2LJBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:31:28 -0500
X-Spam-Score: -100.8
Message-ID: <50C53BA5.2030805@asianux.com>
Date: Mon, 10 Dec 2012 09:32:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [Consult]: Re: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <50BCDDB4.6010608@microgate.com> <50C1513A.4010600@asianux.com>
In-Reply-To: <50C1513A.4010600@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul Fulghum:

  Firstly, sorry for my mistake:
    I am a reporter (not reviewer), and not suitable to review maintainer's patch.
    when you send relative patch, need not cc to me (I am not reviewer)

  so:
    could you send patch again (not need cc to me) ?
      (and also it is better to mark me as Reported-by in your patch)

  sorry for my mistake, again.

gchen.


于 2012年12月07日 10:15, Chen Gang 写道:
> Hello Greg Kroah-Hartman:
> 
> 
> 于 2012年12月04日 01:13, Paul Fulghum 写道:
>> Fix call to line discipline receive_buf by synclink drivers.
>> Dummy flag buffer argument is ignored by N_HDLC line discipline but might
>> be of insufficient size if accessed by a different line discipline
>> selected by mistake. flag buffer allocation now matches max size of data
>> buffer. Unused char_buf buffers are removed.
>>
>> Signed-off-by: Paul Fulghum <paulkf@microgate.com>
> 
> if no additional questions:
>   is it suitable to let this patch pass checking ?
>   at least for me, it is surely solve an issue, and no negative effect.
> 
> now, maybe Paul Fulghum is busy...
>   the left questions what I have sent seems minor.
>   so they can be delayed, until he has free time.
> 
> when Paul Fulghum has free time.
>   can still check what my left questions whether valid.
>   if they are valid, can send additional patch for them.
> 
> 
>   is it OK ?
> 
>   Regards
> 


-- 
Chen Gang

Asianux Corporation
