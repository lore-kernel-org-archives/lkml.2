Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0CTS0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:26:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36200 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0CTS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vzPgLmQfbIeDHluZD+6qGZxH4EOpO985Fmxj+EZtyxtOeAYPowgsXKE5N82hwqF1aH
         r6nfbcd0rrY0dpjs0Pk0A9pqZBJqozg1OdH2ICzHAzOVVVP78Oigmfvsdh9Qu/X6iRBM
         sIK5zQSV5mOhwQqImqXPHZjRsJ2Dt2FEK1Xdo=
MIME-Version: 1.0
In-Reply-To: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com>
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com>
Date: Sat, 20 Mar 2010 11:26:06 -0700
X-Google-Sender-Auth: 6dfc642a1dd270dd
Message-ID: <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
From: Yinghai Lu <yinghai@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 6:12 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hello.
>
> After update to 2.6.34-rc1, I was experimented by strange oopses during
> boot, what looked like memory corruption. Bisection shows that first bad
> commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
> support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
> system. Not sure what info is need to track down this issue, so please
> let me know.

can you check patch

https://patchwork.kernel.org/patch/87081/

Thanks

Yinghai
