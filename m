Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2K3Fcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:32:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44346 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2K3Fca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:32:30 -0500
Message-ID: <50B844DC.308@gmail.com>
Date: Fri, 30 Nov 2012 11:02:12 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Abhijit Pawar <abhi.c.pawar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] fs:sysfs pass NULL as second parameter for set_anon_super
References: <1354170945-12211-1-git-send-email-abhi.c.pawar@gmail.com> <20121129153639.GA6639@kroah.com>
In-Reply-To: <20121129153639.GA6639@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 09:06 PM, Greg Kroah-Hartman wrote:
> On Thu, Nov 29, 2012 at 12:05:45PM +0530, Abhijit Pawar wrote:
>> set_anon_super does not use the second parameter in its implementation.
>> So there is no need to pass on the second parameter.
> 
> Why not just remove the second parameter from the call then?
> 
> thanks,
> 
> greg k-h
> 

This is used as a callback function. So changing the signature will
affect many other filesystems who use the default function rather than
the overridden one.


-- 
-
Abhijit
