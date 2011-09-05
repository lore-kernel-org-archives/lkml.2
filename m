Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab1IEEjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 00:39:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56760 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1IEEjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 00:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <87y5y3zuc5.fsf@devron.myhome.or.jp>
References: <CADDb1s1A38RyioiehzbRCgjFQT-MhfoD7cutxkn+h_cvUcZpfg@mail.gmail.com>
	<CAKYAXd8gLN4C54Ey5uuK+_FY0U+tBf4aHntX=B+d0eNgY=rNsA@mail.gmail.com>
	<87hb4tvoth.fsf@devron.myhome.or.jp>
	<CAKYAXd-XTxA=BNpdYNJOAqN0R7EBMqJj6DgTseCww5prbSvDcg@mail.gmail.com>
	<87y5y3zuc5.fsf@devron.myhome.or.jp>
Date: Mon, 5 Sep 2011 13:39:18 +0900
Message-ID: <CAKYAXd-o3vzOnxtY=NwocOxeBFQoor1x3Bw48x7kT5BhL29ZWA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_vfat_filesystem=3A_Why_utf8=3D1_when_iocharset=3D=E2=80=9Dut?=
	=?UTF-8?Q?f8=E2=80=9D_was_already_there=3F?=
From: NamJae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/5 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> NamJae Jeon <linkinjeon@gmail.com> writes:
>
>> I want to know whether you can integate only iocharset=utf8 with
>> removing utf8 option.
>
> I guess *I* will not do, because I don't have time (and maybe
> motivation) to concentrate it.
>
> Furthermore, even if I had time, I think I will not use current options
> anymore. Instead, I will add new infrastructure like we can support more
> flexible (like kiconv? on freebsd). And I suppose the both
> infrastructures (and options) will be used until it is completely
> migrated.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
Thanks for your reply.
I have a question. Do you know who is nls maintainer ?
I can not find it in MAINTAINERS file.

Thanks.
