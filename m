Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1KNImb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 03:42:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36753 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1KNIma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9twNXMbexaUg2MVC_ZCZczM57U6NsRMZVs8wPFv6f0KUSQ@mail.gmail.com>
References: <CADDKRnCq_h5YPcSCoOnW3q+8Q8r5UV3Wj6oJ4UE5UV+Keb1M1Q@mail.gmail.com>
	<CADDKRnD6oL-WAdDowLoC9e8nqNdg9_coCaS49rfTY2PxCCwZvw@mail.gmail.com>
	<CAPM=9twNXMbexaUg2MVC_ZCZczM57U6NsRMZVs8wPFv6f0KUSQ@mail.gmail.com>
Date: Mon, 14 Nov 2011 09:42:28 +0100
Message-ID: <CADDKRnBU2SXRam4t4VxQHuJ+hYw=8BjstYEVr7hJuK4AxDjWgQ@mail.gmail.com>
Subject: Re: [v32-rc1+] radeon kernel crash
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/13 Dave Airlie <airlied@gmail.com>:
> On Sun, Nov 13, 2011 at 2:20 PM, Jörg Otte <jrg.otte@googlemail.com> wrote:
>> The following commit causes the kernel to crash:
>> commit 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc
>>  "drm/radeon/kms/pm: switch to dynamically allocating clock mode array"
>>
>> It happens at a very early stage. So I have no logs, no displays, no
>> nothing.
>> Reverting 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc fixes the problem.
>> HW is a Thinkpad T43.
>
> Fix is in my drm-fixes tree, will send to Linus now.
>
> Dave.
>

Fix works, thank you very much.
Joerg
