Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2BTPLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:11:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49118 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2BTPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:11:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of xiyou.wangcong@gmail.com designates 10.68.73.138 as permitted sender) smtp.mail=xiyou.wangcong@gmail.com; dkim=pass header.i=xiyou.wangcong@gmail.com
Message-ID: <4F4262A4.9000204@gmail.com>
Date: Mon, 20 Feb 2012 23:11:32 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tao Jiang <jiangtao.jit@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: A problem with percpu variable cpu_number
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com> <CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com> <4F411373.50304@gmail.com> <CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com>
In-Reply-To: <CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 07:04 PM, Tao Jiang wrote:
>
> I read the macor DEFINE_PER_CPU
> it's decorated by some percpu attributes
> it will be put in section .data..percpu in init section

.data..percpu is not .init section, the .init sections should all have 
".init.*" names.
