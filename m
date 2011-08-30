Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1H3Kbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:31:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54787 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1H3Kba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110830111752.0ad76a0d@lxorguk.ukuu.org.uk>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
	<1314639761-4947-4-git-send-email-mark.einon@gmail.com>
	<20110830100834.GC3705@shale.localdomain>
	<20110830111752.0ad76a0d@lxorguk.ukuu.org.uk>
Date: Tue, 30 Aug 2011 11:31:30 +0100
Message-ID: <CANK3SE3V9CwNL=xydkvjuTtnktJyHM7g3s6MSiLRQcS7ppqncQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] staging: et131x: Remove redundant replica loopback code
From: Mark Einon <mark.einon@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan Carpenter <error27@gmail.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 August 2011 11:17, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 30 Aug 2011 13:08:34 +0300
> Dan Carpenter <error27@gmail.com> wrote:
>
>> This patch was sent with git-send-email but it's in base64 encoding.
>>
>> Content-Type: text/plain; charset="utf-8"
>> Content-Transfer-Encoding: base64
>>
>> Why did that happen?
>
> Presumably it got re-encoded because a mail system in the path between
> him and you decided it was traversing a 7bit path and helpfully
> reprocessed it to avoid corruption.
>
> If your mailer can't automatically handle utf-8/base64 perhaps you need a
> better one ;)

Maybe not - now you mention it, when git send-email got to this
particular patch, it did ask me if I wanted to use UTF-8, which it's
never done before.
I'm not aware of anything unusual I did with this patch set, but i've
just done a format-patch and git send-email again to get:

git send-email --to=mark.einon@gmail.com
0004-staging-et131x-Remove-redundant-replica-loopback-cod.patch
0004-staging-et131x-Remove-redundant-replica-loopback-cod.patch
The following files are 8bit, but do not declare a Content-Transfer-Encoding.
    0004-staging-et131x-Remove-redundant-replica-loopback-cod.patch
Which 8bit encoding should I declare [UTF-8]?

Not sure how that's happened.

Mark
