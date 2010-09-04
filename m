Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0IDGvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:51:55 -0400
Received: from freeflow.nu ([178.79.134.28]:56604 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0IDGvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:51:54 -0400
Message-ID: <4C81EC7A.1000806@kernel.org>
Date: Sat, 04 Sep 2010 09:51:38 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] x86-64: Fix %cs value in convert_from_fxsr()
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com> <1283563039-3466-7-git-send-email-brgerst@gmail.com>
In-Reply-To: <1283563039-3466-7-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 4.9.2010 4.17, Brian Gerst wrote:
> While %ds still contains the userspace selector, %cs is KERNEL_CS at
> this point.  Always get %cs from pt_regs even for the current task.
>
> Signed-off-by: Brian Gerst<brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>

