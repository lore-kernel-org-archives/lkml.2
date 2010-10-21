Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab0JUL7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:59:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63193 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab0JUL7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HLapgvvGGpTyOxaWfKzerj10Op3jQM302LCMEuVwe8WJGVZhQEhVcN4vum6/TAB8N/
         787fzDO2ncPZwXnIrIoeYy3pzRbR/3bGJsma1J1jmbcJNX2kaeagl7+DnnzVsaYTwr4m
         9yf2DenAgwTU4bq+HYnHfYuVWHX0N9hPTeNOA=
MIME-Version: 1.0
In-Reply-To: <20101021.031107.226775564.davem@davemloft.net>
References: <1287201209-2101-1-git-send-email-tdent48227@gmail.com>
	<20101021.031107.226775564.davem@davemloft.net>
Date: Thu, 21 Oct 2010 07:59:13 -0400
Message-ID: <AANLkTi=GJ7YLY=da3WRaBcXX3yRA2n1y0CR_4xNaKfL5@mail.gmail.com>
Subject: Re: [PATCH] Drivers: atm: Makefile: replace the use of <module>-objs
 with <module>-y
From: Tracey Dent <tdent48227@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/10, David Miller <davem@davemloft.net> wrote:
> From: Tracey Dent <tdent48227@gmail.com>
> Date: Fri, 15 Oct 2010 23:53:29 -0400
>
>> Changed <module>-objs to <module>-y in Makefile.
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>
> Applied.
>

Thanks
