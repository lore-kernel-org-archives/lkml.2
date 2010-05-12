Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0ELLRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:17:53 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:33765 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab0ELLRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RHCrWWAZCeQ0Dmc8E6bCgYMK4tgk2z9rleGApFNog/3Oc3UDfd0C2As3HMgkBQgzYD
         9n/QhHVXIOAR6eKV+HOh9q8mdjdGriQaHbHiDQIAsass3GKYEzL8hVcPMU8HLSWArxqa
         P+4IVfFymlCSzwDchtYQ6bk24kZQrVdcBjHo4=
MIME-Version: 1.0
In-Reply-To: <20100512083706.GE5718@cr0.nay.redhat.com>
References: <17ea945f6d53443000524eb7cc5c4fc66ee3ecf8.1273396690.git.andre.goddard@gmail.com> 
	<20100512083706.GE5718@cr0.nay.redhat.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 12 May 2010 08:17:30 -0300
Message-ID: <AANLkTinDz8zNrFcziMvpHOLLujYK9AEeQ10uWrrrMC5e@mail.gmail.com>
Subject: Re: [PATCH] mqueue: fix kernel BUG caused by double free() on 
	mq_open()
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sanchin Sant <sanchinp@in.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Américo!

> In the latest git, you already removed the above kfree() since it is
> not necessary. mqueue_delete_inode() will kfree it.
> so why this fix though?

The applied patch is a newer/better version. This is an old version,
please just ignore it. Thank you!
