Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1FOUnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:43:40 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:41569 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab1FOUnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:43:39 -0400
Message-ID: <4DF91973.6050107@corp.free.fr>
Date: Wed, 15 Jun 2011 22:43:31 +0200
From: Yohan <ytordjman@corp.free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic on java mail server
References: <4DF8F1D0.7000907@corp.free.fr>
In-Reply-To: <4DF8F1D0.7000907@corp.free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/2011 19:54, Yohan wrote:
> Hello,
>
> I have a stange kernel panic on a zimbra mail server (mysqld + server in
> java)... when the java process starts the system freeze...
> This is the first time that i have that kind of problem over 70 same
> kind servers.
>
> The hardware has been changed 3 times (2 times on AMD server, 1 time on
> Intel server).
>
> I join the traces on the intel platform, Tyan S7012 MB, 1 CPU Intel
> E5645, 48GB RAM, kernels 2.6.32.41 and 2.6.39.1 without debugging
> enabled and the output with the 2.6.32.41 with debugging enabled.
>
> It was tested on 2.6.32.41 / 2.6.35.13 / 2.6.38.4 / 2.6.38.8 /
> 2.6.39.1.... same thing.
>
> Thanks for helping.
> Yohan
>

Tested on 3.0.0-rc3 without debugging but with profiling, SECCOMP and 
CC_STACKPROTECTOR : when starting the java process, the OS reboot 
without any error message on the serial console.
