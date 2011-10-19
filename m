Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1JSXqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:46:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1JSXqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:46:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=NDwbd2HzvqfcuzqjNjvhUq6d8fCevA5MgNHAi5IP+tg80XAdgky0gIt7eKwKmXqYt
	x+1ma+FoUO2nawX0uwTQA==
MIME-Version: 1.0
In-Reply-To: <20111014203138.5d3460d5@lxorguk.ukuu.org.uk>
References: <201110132203.45394.bzolnier@gmail.com>
	<4E9762DE.1060009@pobox.com>
	<201110141158.33983.bzolnier@gmail.com>
	<CANEJEGtzwQkDG1KmqVizmW8=SWuhYgjH02TgLaQzU-76TYUZZg@mail.gmail.com>
	<20111014203138.5d3460d5@lxorguk.ukuu.org.uk>
Date: Wed, 19 Oct 2011 16:46:27 -0700
Message-ID: <CAMHSBOXBd4u9Vgtgh0D0SfGVwjgE-iNz5_v5P51WJ+x=biOdzg@mail.gmail.com>
Subject: Re: [PATCH] libata: fix for transport xfer attributes
From: Gwendal Grignou <gwendal@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Grant Grundler <grundler@google.com>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes looks good. I will post another one related to sata speed
soon. Also, I have to support slave ATA devices.

Gwendal.

On Fri, Oct 14, 2011 at 12:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>     "xfer_mode   Current transfer mode."
>>
>> I agree with Bartomiej that current behavior is incorrect.
>
> Well we should probably fix the document and add the current transfer
> mode as its own sysfs entry - much less risky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
