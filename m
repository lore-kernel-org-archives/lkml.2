Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1BHMCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:02:40 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40000 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1BHMCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:02:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=wRl4ZkMWB9NzPl7R+gDtY4jklK94QVPsB5auNp2tJMlsrBIBfCk5yF5KbJMMu7J4dj
         6bezwjsexCGoGMZOi82b7Knsu2922YeD3X/9TjNX0cNNcvPqwkEBAVPhUUHiC6uRrVmI
         hhx3u0+1U0irYJOYHMKIHXTOxOIleZw+D50Ac=
MIME-Version: 1.0
In-Reply-To: <20110208112354.GN4384@bicker>
References: <1297163160-23429-1-git-send-email-marek.belisko@open-nandra.com>
	<20110208112354.GN4384@bicker>
Date: Tue, 8 Feb 2011 13:02:37 +0100
Message-ID: <AANLkTik_8p6hGBTFu-V=pgjGEJX4uCAzHZ-pCzOy-y7O@mail.gmail.com>
Subject: Re: [PATCH RFC] staging: olpc_dcon: Remove _strtoul() function.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, jon.nettleton@gmail.com,
        linux-kernel@vger.kernel.org, dilinger@queued.net, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 12:23 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Tue, Feb 08, 2011 at 12:06:00PM +0100, Marek Belisko wrote:
>> olpc_dcon driver use self invented _strtoul  function
>> which make similar check like strict_strtoul just extend
>> for space checking at last string place. Normally access
>> to sys file looks echo 1024 > /sys/... so space could be considered
>> as error character and we could simplify code using just strict_strtoul
>> function instead self invented.
>>
>
> Could you do it on top of the patches that Andres Salomon sent?
patch resend : http://driverdev.linuxdriverproject.org/pipermail/devel/2011-February/011930.html
>
> http://driverdev.linuxdriverproject.org/pipermail/devel/2011-February/thread.html
>
> # [PATCH 1/4] olpc_dcon: get rid of global i2c_client, create a dcon_priv struct   Andres Salomon
> # [PATCH 2/4] olpc_dcon: change sysfs 'output' toggle to be clearer...   Andres Salomon
> # [PATCH 3/4] olpc_dcon: move more variables into dcon_priv   Andres Salomon
> # [PATCH 4/4] olpc_dcon: actually return the value of i2c_add_driver   Andres Salomon
>
> regards,
> dan carpenter
>
>
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
