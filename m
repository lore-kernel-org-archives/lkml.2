Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0IGShN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:37:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0IGShL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=q7w+XTV1vSiNZYIfafX8xyMWIpvrRq4b8lVxgzLZp/kxPY9Lp+qgH8YMNVAOqg6ceQ
         nrz++2JcbpzRXj+jEf8ktYyLzl1RmrKqVt8My1xJBU7n1H7Hjt46BwbYPp8Wq2SXHLVm
         ZYB07vbLKW9iQxoO/WTBaFqu+UsmdasosXbEA=
Date: Tue, 7 Sep 2010 20:21:43 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35.4: sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem
 access errors follow
Message-ID: <20100907202143.02cf60ec@varda>
In-Reply-To: <201009071834.27953.pedrogfrancisco@gmail.com>
References: <201009071834.27953.pedrogfrancisco@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 7 Sep 2010 18:34:27 +0100
Pedro Francisco <pedrogfrancisco@gmail.com> escribió:

> sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow.
> 
> Now what I'm surprised is not the filesystem errors but me being allowed to 
> remove the module without using the '-f' option.
> 
> Do note, lsmod |grep ahci reports something like [this is adapted from a 
> 2.6.32 kernel]:
> 
> ahci                   32200  0
> 
> so it isn't at all surprising I'm being allowed to remove a seemingly unused 
> module. So....
> a) is this supposed to happen?

 Yes afaics. root can do many stupid things if (s)he wants
 including « rm -rf --no-preserve-root / »

> b) do you need any more info?
> 
> P.S.: CC'ing me will probably ensure I'll reply faster but not explicitly 
> needed since I'm subscribed.
