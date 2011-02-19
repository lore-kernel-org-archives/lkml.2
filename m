Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1BSCYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:24:31 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42335 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1BSCY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kvqT4k3Vcn8hZWEqP5b0F2tARWDewF9k7ozoF/aGwn5EZDw7QyNhBs1Zgbz4l2OIv1
         TkcVctB47KHkNiWWKzb3J+OcoeUNx2E+DJLsYQgYHVEDNzJ4oaKTjckURFQIunP7k/0H
         4F8tP33LKW79cDbn9FWKpC+3TiKnR3gTz4nZU=
Message-ID: <4D5F29D9.1080601@gmail.com>
Date: Sat, 19 Feb 2011 03:24:25 +0100
From: Klaas Neirinck <klaas.neirinck@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org,
        Klaas Neirinck <klaas.nerinck@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] Staging: tidspbridge: fixed a brace coding style
 issue
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com> <20110218212752.GJ796@kroah.com>
In-Reply-To: <20110218212752.GJ796@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/2011 22:27, Greg KH wrote:
> On Thu, Feb 17, 2011 at 03:58:45AM +0100, Klaas Neirinck wrote:
>> Fixed a coding style issue.
>>
>> Signed-off-by: Klaas Neirinck<klaas.nerinck@gmail.com>
> This doesn't apply at all to the linux-next tree, what did you do it
> against?
>
> confused,
>
> greg k-h
I did it against 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
as shown in http://www.youtube.com/fosdemtalks#p/u/0/LLBrBBImJt4
great talk btw!

Klaas
