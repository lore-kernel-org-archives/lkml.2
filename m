Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LUWjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:39:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39420 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2LUWjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:39:40 -0500
Message-ID: <50D4E515.5070802@zytor.com>
Date: Fri, 21 Dec 2012 14:39:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/13] x86, 64bit: Set extra ident mapping for whole
 kernel range
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org> <1354089042-10023-4-git-send-email-yinghai@kernel.org> <20121221222840.GB1102@phenom.dumpdata.com> <CAE9FiQWXz1xtgbAocvgXKigKJS1Yqr_CPdiLm4N6=PrUxkoPMg@mail.gmail.com>
In-Reply-To: <CAE9FiQWXz1xtgbAocvgXKigKJS1Yqr_CPdiLm4N6=PrUxkoPMg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 02:35 PM, Yinghai Lu wrote:
> 
> stop #PF handler after init_mem_mapping
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-boot-v7
> 
> stop #PF handler in x86_64_start_kernel, to keep kgdb working.
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-boot-v8
> 

The latter really isn't right but we need someone from the kgdb team to
get involved there.  However, saying we can't evolve the kernel because
of kgdb is not acceptable.

	-hpa


