Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2ANVyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:54:46 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:51290 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757117Ab2ANVyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:54:45 -0500
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.100.10070, virus records: 2536984, updated: 14.01.2012]
Message-ID: <4F11F963.4050900@ru.mvista.com>
Date: Sun, 15 Jan 2012 01:53:39 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Mans Rullgard <mans.rullgard@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Javi Merino <javi.merino@arm.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, Jassi Brar <jaswinder.singh@linaro.org>,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH] ARM: pl330: fix null pointer dereference in pl330_chan_ctrl()
References: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
In-Reply-To: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-01-2012 16:36, Mans Rullgard wrote:

> This fixes the thrd->req_running field being accessed before thrd
> is checked for null.  The error was introduced in abb959f.

    Please also specify summary of that commit in parens.

> Signed-off-by: Mans Rullgard<mans.rullgard@linaro.org>

WBR, Sergei
