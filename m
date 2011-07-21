Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1GUFIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 01:08:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49064 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1GUFIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 01:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MVjnD4pqfOuq-wgoLdpFdTK_rdfd2WZTZU_7WCJL+1Tvg@mail.gmail.com>
References: <1310282853-14550-1-git-send-email-lacombar@gmail.com>
	<CACqU3MVjnD4pqfOuq-wgoLdpFdTK_rdfd2WZTZU_7WCJL+1Tvg@mail.gmail.com>
Date: Thu, 21 Jul 2011 13:08:42 +0800
Message-ID: <CAM_iQpV2Y2bNJRvi0i_pfuHQDK6E92+ADzmwQgkc=+bifCL-OA@mail.gmail.com>
Subject: Re: [PATCH] kconfig/nconf: remove useless conditionnal
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 2:11 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 10, 2011 at 3:27 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> After the test
>>
>>        if (!submenu || ...)
>>                continue;
>>
>> the variable `submenu' can _not_ be NULL, so do not test for this situation.
>>

Yeah, looks good.
