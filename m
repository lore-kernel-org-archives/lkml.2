Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2K0QNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:13:05 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:60109 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2K0QNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:13:02 -0500
Date: Tue, 27 Nov 2012 17:12:50 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 4/6 v5] arm highbank: add support for pl320 IPC
Message-ID: <20121127171250.3984e990@skate>
In-Reply-To: <1354028674-23685-5-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
	<1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
	<1354028674-23685-5-git-send-email-mark.langsdorf@calxeda.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark Langsdorf,

On Tue, 27 Nov 2012 09:04:32 -0600, Mark Langsdorf wrote:

> +int ipc_transmit(u32 *data);

ipc_transmit() looks to me like a way to generic name to be exposed to
the entire kernel.

> +extern int pl320_ipc_register_notifier(struct notifier_block *nb);
> +extern int pl320_ipc_unregister_notifier(struct notifier_block *nb);

Why some "extern" here? You don't have these for the other functions in
this header file.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
