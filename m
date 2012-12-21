Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2LUWf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:35:29 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:45430 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2LUWf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:35:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121221222840.GB1102@phenom.dumpdata.com>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
	<1354089042-10023-4-git-send-email-yinghai@kernel.org>
	<20121221222840.GB1102@phenom.dumpdata.com>
Date: Fri, 21 Dec 2012 14:35:25 -0800
X-Google-Sender-Auth: oGSZ0N4IQO5mc6vfQxOKA5kw8pE
Message-ID: <CAE9FiQWXz1xtgbAocvgXKigKJS1Yqr_CPdiLm4N6=PrUxkoPMg@mail.gmail.com>
Subject: Re: [PATCH v5 03/13] x86, 64bit: Set extra ident mapping for whole
 kernel range
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 2:28 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Perhaps 'spare_directory' ? Or 'spare_table' ?

we have evolved -v7 and -v8 that is using FANCY/FUNNY patch of #PF
handler set page table from HPA.

Please do check if -v7 and -v8 break xen again. (it should not !, but
i only test dom0 once)

stop #PF handler after init_mem_mapping
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot-v7

stop #PF handler in x86_64_start_kernel, to keep kgdb working.
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot-v8

Thanks

Yinghai
