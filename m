Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1BJJSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:18:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62178 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1BJJSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X5fB9TGnHLQEB+OTkQlky0j2Q1ZN3CMeTlOHVWniWh85QOmQhlsyZrFVbI77wXkAMb
         bgZgXRWjeHvsAg+RCe4sAri6J5LKu9f0alL5qzvQfbObU/TQkNqep9MLlw0dcDqyEonV
         iLV2Lli/b5bjQcpINRFeNr41FPwsAWO+0dbhQ=
MIME-Version: 1.0
In-Reply-To: <1297274408.3016.29.camel@mulgrave.site>
References: <201102091515.16202.bzolnier@gmail.com>
	<1297274408.3016.29.camel@mulgrave.site>
Date: Thu, 10 Feb 2011 10:18:47 +0100
Message-ID: <AANLkTimE1H=hos+YMW3Ge9vkETC9f1k1Dt6AMi5iLHGW@mail.gmail.com>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 7:00 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
>> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
>> config option) to allow disabling of scsi_devinfo infrastructure.
>>
>> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
>> (as measured on x86-32):
>
> I don't understand the point of this patch ... without the quirks SCSI
> will do the wrong thing on a whole bunch of stuff.  The savings look to
> be tiny ... since the SCSI module is habitually a lot larger than your
> figures suggest.

The patch was originally done for embedded ATA-only setups.

Thanks,
Bartlomiej
