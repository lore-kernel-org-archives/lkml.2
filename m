Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1BKPKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:10:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57673 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1BKPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N+SyU5zsRYZnlNRLc6YuNwf85TBg4H1+5E9kl/YFvbLYXsdiNGatIHP26v60lpb+wf
         AT1h7KtII8lzaM1nS7he0JYoj3axNmyly5A1/3GqhibHchqIPEWTlZ9rw7IahBFu0jj+
         rba63EMRjgv8bTSlPUhNLLpDUSvuwTQheqdbA=
Subject: Re: [PATCH 6/6] Cpu features overrides for msp platforms.
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110211150403.GG23348@linux-mips.org>
References: <1295943797-20467-1-git-send-email-anoop.pa@gmail.com>
	 <20110211150403.GG23348@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 21:01:20 +0530
Message-ID: <1297438280.29250.74.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 16:04 +0100, Ralf Baechle wrote:
> Queued for 2.6.39, thanks!
> 
> But: this is a rather short cpu-feature-overrides.h file.  You can shrink
> the kernel significantly and get a little performance boost by further
> defines in that file.  In particular defining the symbols for cache and
> TLB properties such as the cpu_dcache_line_size and cpu_icache_line_size
> are very effective.
Can you point me to reference file ?.
> 
>   Ralf


