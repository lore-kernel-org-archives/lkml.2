Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659Ab2EQK73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:59:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57532 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761545Ab2EQK72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:59:28 -0400
Message-ID: <4FB4D9F6.7060401@mvista.com>
Date: Thu, 17 May 2012 14:59:02 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, david.daney@cavium.com
Subject: Re: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with
 irq disabled
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com> <1337249410-7162-7-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1337249410-7162-7-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-05-2012 14:10, Yong Zhang wrote:

> From: Yong Zhang<yong.zhang@windriver.com>

> To prevent a problem as commit 5fbd036b&&  2baab4e9 try to resolve,

    Please also specify the summary of those commits in parens.

> move set_cpu_online() to the uping CPU and with irq disabled.

    Uping? Maybe "brought up"?

> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>

WBR, Sergei

