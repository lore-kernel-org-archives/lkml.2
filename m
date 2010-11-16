Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab0KPNDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:03:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64750 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab0KPNDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:03:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AY/ObpORiVtq3rjCC3WPlat7P0uh5Z0TWeC/dSK4PIPi01Ac9h/KYlz/VnPZ15Zfhq
         3N/n6PCrhalOes9jJpU0pKe+Vq5sbej+tO8JJU2bcIzsRGdt2mOQIAxPYCF5ATlX4S/G
         GchTCfDrq3OF6MPcgkEUnjaiS+5uKFyV6UXFM=
MIME-Version: 1.0
In-Reply-To: <20101116004304.GA31308@quack.suse.cz>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
	<201011152346.41458.arnd@arndb.de>
	<20101116004304.GA31308@quack.suse.cz>
Date: Tue, 16 Nov 2010 14:03:20 +0100
X-Google-Sender-Auth: e7yExvFDQcbJYBf_xr2vkwKK8dk
Message-ID: <AANLkTim8BvuSUzzZf0uN9ux2rzQavosvo+bT2PuWzSVf@mail.gmail.com>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gentlemen,

2010/11/16 Jan Kara <jack@suse.cz>:
[...]
>> Any update on this?
>>
>> I'd really like to see the BKL disabled by default in 2.6.37, and UDF
>> is the final blocker for this now.

>  Allesio sent me another version of patches last week and I sent him today
> some comments (also told him to CC the list next time). I think the next
> iteration should be fine as far as code review is concerned so after some
> testing we can merge it...

I'll provide the updated patches in few hours.

Ciao,
Alessio
