Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2FDDxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:53:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40886 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755774Ab2FDDxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:53:51 -0400
Message-ID: <4FCC3151.1040503@gmail.com>
Date: Mon, 04 Jun 2012 07:53:53 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why minor is still 8 bit?
References: <4FCC0E6D.9000206@gmail.com> <20120604013504.GU30000@ZenIV.linux.org.uk>
In-Reply-To: <20120604013504.GU30000@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04.06.2012 05:35, Al Viro wrote:
> On Mon, Jun 04, 2012 at 05:25:01AM +0400, George Shuklin wrote:
>> I've understand that major and minor numbers for device is 8-bit size.
>>
>> I've don't understand, WHY? In 2012!
>>
>> (I've just have some discussion about 8-bit counter limitations in
>> context of cloud computing. In middle of 2012!!!!)
> Yes, shocking.  It's been several years and you are still using that
> buzzword; I mean, it's _so_ 2010...  Should've moved on to whatever's
> in this year...
>
> Incidentally, minors are 20 bit and majors are 12, but don't let that
> stand in the way of righteous indignation - what's mere facts when
> one is having discussions in context, presumably leveraging synergies
> all along...
Ok, thank you for information.

But question is almost same: can I have 30k active logical volumes on my 
single server, please?
