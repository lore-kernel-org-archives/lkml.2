Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1HVMsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:48:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33373 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1HVMsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E5153D8.7010607@gmail.com>
References: <4E5153D8.7010607@gmail.com>
Date: Mon, 22 Aug 2011 21:48:49 +0900
Message-ID: <CAC5umyh3S0Xrc0OOXk7TzsQqF0t1ostKtR_5hqFwN_EkcgwuxA@mail.gmail.com>
Subject: Re: module param for CPU_NOTIFIER_ERROR_INJECT
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/22 Justin P. Mattock <justinmattock@gmail.com>:

> example 2
> # modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
> # echo 1 > /sys/devices/system/cpu/cpu1/online
> bash: echo: write error: No such file or directory
>
> is not working for me, or atleast is not showing me any info that it is
> working.

I suspect that cpu-notifier-error-inject module is already loaded and
the module parameter is just ignored when you run above commands.

Please retry it after rmmod or change that parameter through
/sys/module/cpu-error-inject/parameters/cpu_up_prepare_error.
