Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2BUH2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 02:28:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34825 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2BUH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 02:28:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of xiyou.wangcong@gmail.com designates 10.68.234.132 as permitted sender) smtp.mail=xiyou.wangcong@gmail.com; dkim=pass header.i=xiyou.wangcong@gmail.com
Message-ID: <4F434789.9080608@gmail.com>
Date: Tue, 21 Feb 2012 15:28:09 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yang Honggang <eagle.rtlinux@gmail.com>
CC: hjk@hansjkoch.de, linux-kernel@vger.kernel.org
Subject: Re: Is there a mail list dedicated for UIO (userspace I/O)?
References: <4F43BCDB.90606@gmail.com>
In-Reply-To: <4F43BCDB.90606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 11:48 PM, Yang Honggang wrote:
> hi, everyone
>
> Is there a mail list dedicated for UIO (userspace I/O)?
> I want to contribute to UIO but did not find the right
> mail list.

At least get_maintainer.pl said it it LKML:

% ./scripts/get_maintainer.pl -f drivers/uio
"Hans J. Koch" <hjk@hansjkoch.de> (maintainer:USERSPACE I/O (UIO))
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (maintainer:USERSPACE 
I/O (UIO))
linux-kernel@vger.kernel.org (open list)
