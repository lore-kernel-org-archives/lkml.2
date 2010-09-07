Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0IGMnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:43:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44522 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0IGMnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xJp4MAEAQqKdRuGuzqQSo+BsVa0nYFhicsM/vq2KbrP93QaGma04GMcdUGZrj8EbcH
         jaWcoRDWjM+fp5xmjh+yfwqQgiyx+e/1gtfpEua2NCPM0zD1XMRP+TfVuo5R2CAwhYjA
         3v2CwLQYHuyMOYmL9SzLPoil7odVEQq1VSvJk=
MIME-Version: 1.0
In-Reply-To: <20100907061614.GA2925@kroah.com>
References: <1283837309.6302.4.camel@lenovo> <20100907061614.GA2925@kroah.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 7 Sep 2010 08:43:31 -0400
Message-ID: <AANLkTingSKKf5Laqke+nV6u7yrgZby5kyRcos2t6DEPb@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging: xgifb: Removes unnecessary log
To: Greg KH <greg@kroah.com>
Cc: "Prashant P. Shah" <pshah.mumbai@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So this patch removes the unnecessary log.
>
> Unfortunatly it doesn't apply as you and Prashant seem to like to modify
> the same file on the same day.  Prashant's patch is now in my tree, so
> you need to redo this one.  I suggest you two get together and
> coordinate this so I can stop rejecting every other patch from both of
> you :)
>
> thanks,
>
> greg k-h
>

Ok Greg, I will redo this patches. Thanks a lot

-- 
Best regards,

-----------------------------------------
Javier Martínez Canillas
+595 981 88 66 58
