Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab2IRIGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:06:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40146 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2IRIGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:06:18 -0400
Message-ID: <50582B75.7080608@gmail.com>
Date: Tue, 18 Sep 2012 10:06:13 +0200
From: Johannes Thumshirn <morbidrsa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, grabner@icg.tugraz.at
Subject: Re: staging: Line6 - Steps needed to get driver out of staging area
References: <50560C5F.3020700@gmail.com> <20120917202238.GA18748@kroah.com>
In-Reply-To: <20120917202238.GA18748@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:22 PM, Greg KH wrote:
> On Sun, Sep 16, 2012 at 07:29:03PM +0200, Johannes Thumshirn wrote:
>> Hi LKML,
>>
>> I wanted to ask for the steps that are needed to get the line6
>> driver out of the staging area (apart from minor getpatch.pl fixes).
> First try asking on the proper mailing list :)
>
> Second, it needs to be submitted to the subsystem that it should be in
> (i.e. sound, right?)  It's up to those maintainers to say what's left to
> do.
>
> Are you willing to help out with this?  Right now it doesn't seem like
> anyone is using the driver, or helping to clean it up.
>
> thanks,
>
> greg k-h
Ok, then I'll ask on the sound mailing list for a todo-list.

Yes I'm willing to do the maintenance of this driver if the original
author doesn't want to take it up again.

Thanks for your answer.

Johannes
