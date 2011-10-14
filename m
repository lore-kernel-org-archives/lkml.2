Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1JNTMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:12:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27657 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1JNTMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:12:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Nj6VTOwgSakizUvd2+RgjXmes2gAt3ryfUuyOq+xbBru3h874GD7imB3DAs3Od/kg
	lalE0WhGKVO7n3OkPyWyQ==
MIME-Version: 1.0
In-Reply-To: <201110141158.33983.bzolnier@gmail.com>
References: <201110132203.45394.bzolnier@gmail.com>
	<4E9762DE.1060009@pobox.com>
	<201110141158.33983.bzolnier@gmail.com>
Date: Fri, 14 Oct 2011 12:12:26 -0700
Message-ID: <CANEJEGtzwQkDG1KmqVizmW8=SWuhYgjH02TgLaQzU-76TYUZZg@mail.gmail.com>
Subject: Re: [PATCH] libata: fix for transport xfer attributes
From: Grant Grundler <grundler@google.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Gwendal Grignou `" <gwendal@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 2:58 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
...
>> "fix" or not it is an ABI change... who is impacted?  Has anyone used
>> the current, pre-patch behavior as documented?
>
> I doubt that anyone has used it given the current incorrect behavior but lets
> ask libata transport authors..

Gwendal is the primary author.

I'm not aware of any uses either.

Based on this kernel.org documentation:
    http://www.kernel.org/doc/Documentation/ABI/testing/sysfs-ata

    "xfer_mode   Current transfer mode."

I agree with Bartomiej that current behavior is incorrect.

cheers,
grant
