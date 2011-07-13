Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1GMOFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 10:05:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59822 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1GMOFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 10:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <8F0C2E89B9AA20448D482EB589641EB3010264C7E2@orsmsx507.amr.corp.intel.com>
References: <1310350888180@xenotime.net>
	<8F0C2E89B9AA20448D482EB589641EB3010264C7E2@orsmsx507.amr.corp.intel.com>
Date: Wed, 13 Jul 2011 17:05:51 +0300
Message-ID: <CAGTPOqee2Gf04p_v6PGw3Vewbpzw1N5BJKZ=QPsdLhWDzBLenQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] wimax: delete struct wimax_dev field rfkill_input
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
        linux-wimax <linux-wimax@intel.com>,
        "wimax@linuxwimax.org" <wimax@linuxwimax.org>,
        Vitaliy Ivanov <vitalivanov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:33 PM, Perez-Gonzalez, Inaky
<inaky.perez-gonzalez@intel.com> wrote:
>
> Hi Randy
>
>>From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> "make htmldocs" warns that struct member "rfkill_input" does not have
>> a description.  After searching all kernel .[hc] files, this field
>> is not used, so remove it.
>
> Vitaly sent a patch a couple weeks ago to do this same cleanup.
>
> Thank you anyway!

Yes, it's in David's net-next tree:

http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h=c6af9c406ceb3434281cf230938453931dcbab75

Thanks,
Vitaliy
