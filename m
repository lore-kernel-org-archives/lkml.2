Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2DUVWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 17:22:18 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:64350 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2DUVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 17:22:18 -0400
Message-ID: <4F932506.8040606@molgaard.org>
Date: Sat, 21 Apr 2012 23:22:14 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120421 Firefox/14.0a1 SeaMonkey/2.11a1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Boot failure since 3.3-rc?
References: <4F931C6D.8040407@molgaard.org> <CAE9FiQVSWSNt6MVGU6MiHozpcbjyzukvM++E5kEv5BSsS-nbzw@mail.gmail.com>
In-Reply-To: <CAE9FiQVSWSNt6MVGU6MiHozpcbjyzukvM++E5kEv5BSsS-nbzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:

> So kernel with reverting that commit will work well?

Being new to reporting bisect results, I stupidly forgot to realise that 
this would be the final proof. Will report back when I know.

> can you post boot with "debug ignore_loglevel initcall_debug" with and
> without reverting that patch?

Need to read up on netconsole as it's a headless machine. Would 
netconsole work through a switch, or would I need to find a cross-over 
cable?

> Thanks
>
> Yinghai

Thanks for replying. Will report back when I have something to share.

Best regards,

Sune

-- 
Being powerful is like being a lady. If you have to tell people you
are, you aren't.
- Margaret Thatcher


