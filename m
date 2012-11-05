Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2KEJPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:15:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60813 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2KEJPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:15:36 -0500
MIME-Version: 1.0
In-Reply-To: <E3FFC807-CA31-45EA-A8EF-1266A27F9A0D@vulytrampolines.com>
References: <E3FFC807-CA31-45EA-A8EF-1266A27F9A0D@vulytrampolines.com>
Date: Mon, 5 Nov 2012 10:15:34 +0100
Message-ID: <CAFLxGvx_ASg3=dspS33ajsT5DJgNqsz2TmTY8b+k9BfmGhHXwg@mail.gmail.com>
Subject: Re: Network routing problem after upgrading to 3.6.2
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Melby Sjamsuddin <melby.s@vulytrampolines.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 10:02 AM, Melby Sjamsuddin
<melby.s@vulytrampolines.com> wrote:
> I have a network issue with two routers at work. They're setup with vrrp and do load balancing with
> 'ip route nexthop' and iptables connmark, using different vlan to connect to different modems.
>
> They have been working fine until recently where suddenly http connections just never finish
> loading and very slow. I thought it was just slow until I recall that it started to happen after fedora 16
> updated the kernel to 3.6.2.
>
> If I boot to older kernel (3.4.11), everything becomes normal again.

Does 3.5 work?
Please find out the exact release where it broke...

-- 
Thanks,
//richard
