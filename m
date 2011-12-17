Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1LQN0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:26:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54858 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1LQN0C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:26:02 -0500
MIME-Version: 1.0
In-Reply-To: <4EEC5286.3070408@gmx.de>
References: <4EEC5286.3070408@gmx.de>
Date: Sat, 17 Dec 2011 14:26:01 +0100
Message-ID: <CAFLxGvxjLCyMCPXtpm7a7RaOL4A4=bhCLPKD=FVAc8xOdx_CsQ@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_Kernel=2DDOS_error_in_arp_mechanism_=96_no_delete_?=
	=?windows-1252?Q?off_incomplete_arp_adresses?=
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Robert Gladewitz <gladewitz@gmx.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 9:27 AM, Robert Gladewitz <gladewitz@gmx.de> wrote:
> Hello,
>
> first i have to say sorry for m y bad english. I try my best to descripe the
> error.
>
> I Use Linux-Routers for internal and external firewall components. For this
> I Use own kernel configurations und use only the drivers an modules what I
> need. Other features and modules I deactivated in my kernel versions
>
> Since the kernel version 2.6.36 there is some mistake in the ipv4 arp
> implementation. The the System try to find an unknown system, the send an
> “who is” and marked the ip address as “incomplete” (German: unvollständig).
> The thing is, usually linux delete all incomplete and complete entries in
> some time, but in all kernel versions since 2.6.36 he doas not delete any
> addresses.
>
> In my case, I scan my network-segmens for new devices (Kaspersky, Landesk)
> and on this process, the router learned a lot of incomplete addresses. I
> have some class b networks (from the history), and this means the router
> will be learned mor then 2^16 adresses.
>
> Now the kerlen learn a maximum addresses – I know this is defined on
> gc_thresh1 , gc_thresh2 and gc_thresh3 in the proc system under
> sys.net.ipv4.neight.default. If the table have the maximum addresses in the
> table (default=1024), no new host can send traffic packet over this router.
> This means, we have a classical risk of DOS. In my case, I have only an
> internal risk, but some providers may have also external risc.
>
> I hope, my description help you to find this error. I send also my kernel
> config, may there is some relation to small configurations in kernel
>
> Viele Grüße
>
> Robert Gladewitz
>

CC'ing netdev.

-- 
Thanks,
//richard
