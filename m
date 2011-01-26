Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1AZTQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:16:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1AZTQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:16:49 -0500
Message-ID: <4D4072F9.5060206@redhat.com>
Date: Wed, 26 Jan 2011 20:16:09 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com> <4D402D35.4090206@redhat.com> <20110126165132.GC29163@core.coreip.homeip.net> <4D4059E5.7050300@redhat.com> <20110126182415.GB29268@core.coreip.homeip.net>
In-Reply-To: <20110126182415.GB29268@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

>>> The check should be against concrete version (0x10000 in this case).

Stepping back: what does the version mean?

0x10000 == 1.0 ?
0x10001 == 1.1 ?

Can I expect the interface stay backward compatible if only the minor 
revision changes, i.e. makes it sense to accept 1.x?

Will the major revision ever change?  Does it make sense to check the 
version at all?

thanks,
   Gerd

