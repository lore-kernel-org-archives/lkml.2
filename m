Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab0KBG6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 02:58:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33239 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0KBG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 02:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=syw5Mq93vtKiPycFWKvVPbdy2cgBXDkoEP7f3VjdgSVLJOkwW7RjikSiHIXKRu803i
         FZrIOTbYX0RCsWME98m3P+ey1icuVODYv3EFevMpOv7985Ne+NUcfQ1RS5aqOysX1c+2
         S/+Hspynolhl39uAv5+xow1wkIDKfZ4+xqX5U=
Date: Tue, 2 Nov 2010 15:02:43 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to prevent + being appended to kernel image name
Message-ID: <20101102070243.GA5270@cr0.nay.redhat.com>
References: <D1A25074-F603-450B-BF77-FED5FAFC54C5@mac.com>
 <28DC96E3-C6A9-4D5D-984F-C11EB7E932FC@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28DC96E3-C6A9-4D5D-984F-C11EB7E932FC@mac.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 12:26:20AM +0400, Elvis Dowson wrote:
>Hi,
>
>On Oct 25, 2010, at 11:54 PM, Elvis Dowson wrote:
>
>> How can I prevent the + symbol from being prefixed to the kernel image name? 
>
>I found the solution. You can disable the plus sign is the LOCALVERSION environment variable or make variable:
>
>make LOCALVERSION= all
>
>make ARCH=arm CROSS_COMPILE=arm-angstrom-linux-gnueabi- LOCALVERSION=  -j6 uImage
>

Correct, kbuild will append '+' if you modify the source code unless you provide
LOCALVERSION=.

