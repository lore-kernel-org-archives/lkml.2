Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2BSMUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 07:20:34 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37066 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab2BSMUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 07:20:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jiangtao.jit@gmail.com designates 10.152.104.143 as permitted sender) smtp.mail=jiangtao.jit@gmail.com; dkim=pass header.i=jiangtao.jit@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com>
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com>
Date: Sun, 19 Feb 2012 20:20:31 +0800
Message-ID: <CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
Subject: A problem with percpu variable cpu_number
From: Tao Jiang <jiangtao.jit@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I've asked the question on kernelnewbies, no replies.
So forward it here.
Thank you.


---------- Forwarded message ----------
From: tao jiang <jiangtao.jit@gmail.com>
Date: 2012/2/16
Subject: A problem with percpu variable cpu_number
To: kernelnewbies <kernelnewbies@kernelnewbies.org>


Hi :

At the beginning of start_kernel() -- init/main.c
boot_cpu_init() is called

and in boot_cpu_init() will call smp_processor_id()
it's a macro
and it will be expanded as (percpu_read(cpu_number)) and so on

but i noticed that it's before setup_per_cpu_areas() in start_kernel()
is that mean the percpu areas hadn't be initialized yet
but why smp_processor_id() could be called before setup_per_cpu_areas()


Thank you.

---------------
jiangtao
