Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195Ab2CFLfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:35:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57407 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965129Ab2CFLfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:35:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paolo.bonzini@gmail.com designates 10.50.77.138 as permitted sender) smtp.mail=paolo.bonzini@gmail.com; dkim=pass header.i=paolo.bonzini@gmail.com
Message-ID: <4F55F669.8090900@redhat.com>
Date: Tue, 06 Mar 2012 12:35:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] block: avoid false positive warnings on ioctl to partition
References: <1329464338-8351-1-git-send-email-pbonzini@redhat.com> <4F4B78CE.4010405@redhat.com> <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com>
In-Reply-To: <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/02/2012 01:14, Linus Torvalds ha scritto:
> So I'm still not convinced this is safe, and feel a bit worried about
> us possibly silently missing some things. That
> 
>    default:
>       return -ENOIOCTLCMD;
> 
> is what worries me.
> 
> Blocking the ones we *know* about and understand I'm perfectly fine
> with. And the SG_IO case looks fine. It's the possibly unknown users
> that still worry me.

Are you okay with applying this at the beginning of the next merge window?

My worry is that people get desensitized to the warnings.  As time
passes, the likelihood decreases that an actual problem is reported.

Paolo
