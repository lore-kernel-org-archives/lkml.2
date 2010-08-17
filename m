Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab0HQVxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:53:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53392 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab0HQVw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TZFUYkkiWzyOATfuTNdhlsoOcVtp+/+te7rnY6Nh5K7gz4Xcyt+4WstiutsXyfsGsg
         yNYf3mRacfO16FXp2yIacx/gfyZ0VR3TKL4Xj8qG4ED0/wTgAjSYftNk2Pp3LEBvgEjn
         YgvQCFXqDY69FGO34kxi71jhm37nZYOKqUHl0=
Message-ID: <4C6B04AE.1030304@pobox.com>
Date: Tue, 17 Aug 2010 17:52:46 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [patch] pata_winbond: fix module init
References: <20100803152549.GQ26313@bicker> <201008162123.03208.bzolnier@gmail.com>
In-Reply-To: <201008162123.03208.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 03:23 PM, Bartlomiej Zolnierkiewicz wrote:
>
> Hi Dan,
>
> On Tuesday 03 August 2010 05:27:47 pm Dan Carpenter wrote:
>> winbond_init_one() returns 0 on success and an error code on failure.
>> In the original code, we always just released the regions and return
>> -ENODEV.  This was introduce in 2006 by 7e45b0e5f6f6 "[PATCH] libata:
>> Winbond support".
>
> You might like to pick up
>
> 	http://patchwork.ozlabs.org/patch/39358/

Picked it up...


