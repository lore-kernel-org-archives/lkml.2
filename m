Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0FWIwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:52:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64867 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0FWIwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <201006230852.36290.oneukum@suse.de>
References: <AANLkTilzxC6OdOCGiVfa6a7FMZXWRLNnPZ5lhTNnWCV4@mail.gmail.com>
	<201006230852.36290.oneukum@suse.de>
Date: Wed, 23 Jun 2010 18:52:10 +1000
Message-ID: <AANLkTint3zZuH7bi4cHQFyB1p3faMwXH5d_FDTF4aEvI@mail.gmail.com>
Subject: Re: help identify wwan card
From: Alexander Samad <alex@samad.com.au>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, yes very true, and I ended up finding it :)

as my wife says I had a boy look !



On Wed, Jun 23, 2010 at 4:52 PM, Oliver Neukum <oneukum@suse.de> wrote:
> Am Mittwoch, 23. Juni 2010, 04:53:49 schrieb Alexander Samad:
>> Hi
>>
>> I have got a new laptop HP 2540p, it has a qualcom 3g card, I had one
>> in my hp mini and was able to get it to work with the qcserial module.
>>
>> now I can't find it on my new laptop.
>
> qcserial is a USB driver. You certainly won't find a USB device with lspci.
> You need lsusb.
>
>        Oliver
>
>
