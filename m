Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0FNXyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:54:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50884 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0FNXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kP9tIyzSDnEvW53bAP5UHxKPuOmqIFnFOSPoXRCwPG2dBGGiNmxnrZgQPrsckyXiKm
         QFhT48YpFIvQUbbq3WFE85b3/cVnSDrjcXH/EGgIDBtG70HoMCTt2WvQmbFCeqNJKKmP
         baA/x5gUim+Hl9NSxaHVjZoPGULpJqp2uBnP8=
Message-ID: <4C16C0F9.8090402@gmail.com>
Date: Mon, 14 Jun 2010 17:53:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Emanuele <rob@emanuele.us>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Testing to see if a driver is loaded
References: <AANLkTilZkfvBiwliJ6JKXfvS0V3cvO_AAIj6quegvYgq@mail.gmail.com>
In-Reply-To: <AANLkTilZkfvBiwliJ6JKXfvS0V3cvO_AAIj6quegvYgq@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2010 10:33 PM, Robert Emanuele wrote:
> Greetings once again,
>
> I was wondering if there is a simple way to test if a driver is loaded
> from within another driver's probe?  I have one driver that depends on
> another.  I see several *_find_device functions in
> include/linux/device.h.  I haven't found a "find driver" nor an
> arbitrary way of doing that.
>
> Thanks for any guidance,

There's not a simple answer, it depends what you are trying to achieve 
(i.e. in what way is the driver dependent on the other one..)
