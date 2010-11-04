Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0KDG6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:58:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41676 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0KDG6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pOPKt1h8aZNrgxXg3i19+wzWL3Me3sfxH1BOxhbzq5Sk0waOxpshO6tDKW2RuZ1mCO
         wtQ2k7NGn92WCEwHpav/aODZe3j8x5TGpSGZx7CPxCMchMFcCXyg4Sh7UMuI1RN2hqxO
         XwtX+j1S8opPQeP6FHbp+Qu9UUBBpJanBFvcM=
MIME-Version: 1.0
In-Reply-To: <20101103145713.GA2000@jenkins.mit.edu>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
	<1288779595-15793-7-git-send-email-marek.belisko@gmail.com>
	<20101103145713.GA2000@jenkins.mit.edu>
Date: Thu, 4 Nov 2010 07:58:08 +0100
Message-ID: <AANLkTi=HhYNQz5Nb6vGiC+OauOqPEHG4mxPa4xCxtSVX@mail.gmail.com>
Subject: Re: [PATCH 7/9] staging: ft1000: Get rid of BOOLEAN typedef usage.
From: Belisko Marek <marek.belisko@gmail.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 3:57 PM, Brandon Philips <brandon@ifup.org> wrote:
> On 11:19 Wed 03 Nov 2010, Marek Belisko wrote:
>> -   BOOLEAN                 bGoodVersion;
>> +   u8                 bGoodVersion;
>
> Please use the bool type instead of u8. Might as well do FALSE/TRUE ->
> false/true while you are at it :)
Thanks for comment. Already send patch v2.
>
> Cheers,
>
>        Brandon
>

BR,

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
