Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0GIUrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:47:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0GIUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RWtTWRW9Hd1Cv0AyOtCoE9yEe0JU9Cpk0vELDdQhbaecgOaHp+NDkC0uxDWCwPS7fl
         xN9+I6ksEjKJw6zzuGlCp9JX/7lxzM//VTHN2sydzekAF9i/Xu4ihV9tvIwIwM00iaW5
         I3WpY/+tuoUvyJUQaDYyeLTqnaxUoDPUhFiMQ=
Message-ID: <4C378AD9.1070602@gmail.com>
Date: Fri, 09 Jul 2010 22:47:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>, Christopher Li <sparse@chrisli.org>,
       Linux-Sparse <linux-sparse@vger.kernel.org>
Subject: Re: Warning message when using sparse
References: <4C3680D1.5070601@lwfinger.net>
In-Reply-To: <4C3680D1.5070601@lwfinger.net>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 03:52 AM, Larry Finger wrote:
> On recent kernels, sparse reports the following message for every source
> file that is processed. The warning does not seem to affect the results.
> I'm not sure when the problem started, but I think it was with 2.6.35-rc1.
> 
> 
>   CHECK   drivers/staging/rtl8712/rtl871x_rf.c
> /home/finger/linux-2.6/arch/x86/include/asm/cpufeature.h:297:21: error:
> Expected ( after asm
> /home/finger/linux-2.6/arch/x86/include/asm/cpufeature.h:297:21: error:
> got goto
> 

Yeah, I posted a support for that already:
http://git.kernel.org/?p=devel/sparse/chrisl/sparse.git;a=summary

The patch is not 100% correct, it doesn't support asm volatile goto and
similar.

What distro you use? I will fix it in opensuse (which provide gcc 4.5
already), if there will be no new release of sparse.

regards,
-- 
js
