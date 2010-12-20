Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0LTLDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:03:44 -0500
Received: from payne.is.scarlet.be ([193.74.71.226]:42857 "EHLO
	payne.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab0LTLDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:03:43 -0500
Message-ID: <4D0F380C.6010902@scarlet.be>
Date: Mon, 20 Dec 2010 11:03:40 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Help: major pppoe regression since 2.6.35 (panic on first ppp
 conection)?
References: <4D0C9BFA.4080003@scarlet.be>
In-Reply-To: <4D0C9BFA.4080003@scarlet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/18/2010 11:33 AM, Joel Soete wrote:
> Hello all,
>
[snip]
>
> As in general this kind of problem is quickly identified and solved, I
> do some more test with 2.6.36 and even 2.6.37-rc? releases, in smp or up
> config, with or without netfilter, with or without foreign nvidia
> graphical driver but this issue is still there for me?
>
[snip]

Hello,

Just a small update because I read that there is a pppoe fix in latest testing kernel 2.6.37-rc6 but unfortunately it 
doesn't help me :<(.

Tx,
	J.

PS: I also test kernels 32 and 64 bits without any success.
