Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2KKV7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 16:59:35 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49321 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2KKV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 16:59:34 -0500
Message-ID: <50A01FB1.1080502@gmail.com>
Date: Sun, 11 Nov 2012 16:59:13 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: George Zhang <georgezhang@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        davem@davemloft.net, gregkh@linuxfoundation.org
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming
References: <854640502.31217031.1352140335740.JavaMail.root@vmware.com>
In-Reply-To: <854640502.31217031.1352140335740.JavaMail.root@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 01:32 PM, George Zhang wrote:
> Sasha,
> There is a 'brief' implementation notes aboutVSOCK protocol family
> in af_vsock.c. More about user space layer socket programming is from
> VMCI Socket Programming Guide. (remove crosstalk@vmware.com for email bouncing).
> thanks,
> George

So all the documentation I see in the VMCI Socket Programming Guide is about
userspace programming, and the documentation in af_vsock.c is all around
implementation considerations.

Is there anything that documents the actual protocol? Just for example, whats
the deal with REQUEST/REQUEST2? it appears like something to deal with legacy
code, but I'd really like to have it documented somewhere instead of trying
to figure how everything works by looking at the code.


Thanks,
Sasha



