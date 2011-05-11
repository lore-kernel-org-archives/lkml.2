Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1EKP6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:58:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49326 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab1EKP6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XLyS/tpa4Fbp6JRZIf05Iu/+RBBKFGXVPIzwWIo7vr73idBOgC3bsk0sQ5dQWRnx6T
         OHit3E5zIz2T8XFjxAfXkNXuMH+JzjEsYuDr5vN+b7VBvMvAGS2QVhD8++j4HKm+75HK
         LTJ1ezxp7Mt8qFz6GKXCvNOs5Y0sgaS3MwL7Q=
MIME-Version: 1.0
In-Reply-To: <8883108.HpZuVnkiNA@donald.sf-tec.de>
References: <1304943577-2876-1-git-send-email-jianyunff@gmail.com> <8883108.HpZuVnkiNA@donald.sf-tec.de>
From: li jianyun <jianyunff@gmail.com>
Date: Wed, 11 May 2011 21:17:25 +0800
Message-ID: <BANLkTi=PyObf4pm7xF8jT7hcDgpJVrCdSg@mail.gmail.com>
Subject: Re: [PATCH v2] Add Marvell UMI driver
To: Rolf Eike Beer <eike@sf-mail.de>
Cc: James.Bottomley@suse.de, Jianyun Li <jyli@marvell.com>,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/10 Rolf Eike Beer <eike@sf-mail.de>:
>
>
>> +static unsigned char tag_is_empty(struct tag_stack *st)
>> +{
>> +     if (st->top == 0)
>> +             return 1;
>> +     else
>> +             return 0;
>> +}
>
> The return value should be bool. But I don't think this function is worth it,
> I can only find one place where it is used at all.
>

it may be easy to understand. so I am not modify it.
