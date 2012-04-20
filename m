Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2DTRsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:48:22 -0400
Received: from lulu.zabbo.net ([69.168.54.52]:43655 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab2DTRsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:48:20 -0400
Message-ID: <4F91A161.4040005@zabbo.net>
Date: Fri, 20 Apr 2012 13:48:17 -0400
From: Zach Brown <zab@zabbo.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com> <4F91862F.2030502@zabbo.net> <x49aa26wedf.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49aa26wedf.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Bypassing the page cache is different from bypassing the underlying
> device's cache.  O_DIRECT does not mean "straight to platter".

Sure, sure, you and I know that.

> They most certainly should be!

Are they?

I have my guess.

- z
