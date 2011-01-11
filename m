Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1AKJWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:22:06 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62772 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ltB7BmVhN6F+kp3IiKkR5MPPu1tmiesQrq/5ebZtD8Ty+zTZuRlk88fTKaI/+2jujl
         kWivZDraIqNdGDHKUqG+Hpv01LTvbVUwMRtXaVm5ZJg9aWq4HxvNbg7l38ATqYoYJric
         6/t7gjwsOXIkW2bXZjGeHpuJq+EV78WlZUO3c=
MIME-Version: 1.0
In-Reply-To: <1294731467.17779.352.camel@pasglop>
References: <4D2A1382.7010407@kernel.org>
	<4D2AC6BF.3010907@kernel.org>
	<4D2BA8FE.9090204@kernel.org>
	<4D2BAA75.60001@kernel.org>
	<20110111010714.GB32585@kroah.com>
	<4D2BB048.2050509@kernel.org>
	<1294723290.17779.349.camel@pasglop>
	<4D2BF9F3.5080709@kernel.org>
	<1294731467.17779.352.camel@pasglop>
Date: Tue, 11 Jan 2011 01:21:58 -0800
X-Google-Sender-Auth: ecL_RaprH9TdGhUSstyLO4FqYtY
Message-ID: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
Subject: Re: [PATCH -v3 1/4] pci, usb: Make usb handoff func all take base remapping
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 11:37 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2011-01-10 at 22:34 -0800, Yinghai Lu wrote:
>>
>> system_state does not work.
>> it only have BOOTING and RUNNING ...
>> RUNNING is set in init/main.c::init_post().
>> so early_quirk and pci_quirk all with BOOTING stage...
>
> Or we can make msleep() itself safe...

still think the function pointer is more clean and safe.

Yinghai
