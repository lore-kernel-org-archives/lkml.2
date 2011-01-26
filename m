Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1AZO6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:58:32 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:9171 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841Ab1AZO6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:58:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAEfFP01Ld/sX/2dsb2JhbAAMhAbNT5BogSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,380,1291611600"; 
   d="scan'208";a="89299332"
Message-ID: <4D403693.50702@teksavvy.com>
Date: Wed, 26 Jan 2011 09:58:27 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com>
In-Reply-To: <4D4004F9.6090200@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 06:26 AM, Mauro Carvalho Chehab wrote:
..
> However, as said previously in this thread, input-kbd won't work with any
> RC table that uses NEC extended (and there are several devices on the
> current Kernels with those tables), since it only reads up to 16 bits.
> 
> ir-keytable works with all RC tables, if you use a kernel equal or upper to
> 2.6.36, due to the usage of the new ioctl's.

Is there a way to control the key repeat rate for a device
controlled by ir-kbd-i2c ?

It appears to be limited to a max of between 4 and 5 repeats/sec somewhere,
and I'd like to fix that.

???
