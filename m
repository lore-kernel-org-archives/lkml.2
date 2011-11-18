Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1KRI5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:57:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51090 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1KRI5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:57:13 -0500
Message-ID: <4EC61DB1.3090608@mvista.com>
Date: Fri, 18 Nov 2011 12:56:17 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 2/2] hugetlb: Provide safer dummy values for HPAGE_MASK
 and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-11-2011 1:57, David Daney wrote:

> From: David Daney<david.daney@cavium.com>

> It was pointed out by David Rientjes that the dummy values for
> HPAGE_MASK and HPAGE_SIZE are quite unsafe.  It they are inadvertently
> used with !CONFIG_HUGETLB_PAGE, compilation would succeed, but the
> resulting code would surly not do anything sensible.
>
> Place BUG() in the these dummy definitions, as we do in similar
> circumstances in other places, so any abuse can be easily detected.
>
> Since the only sane place to use these symbols when
> !CONFIG_HUGETLB_PAGE is on dead code paths, the BUG() cause any actual
> code to be emitted by the compiler.

    You mean "doesn't cause"?

> Cc: David Rientjes<rientjes@google.com>
> Signed-off-by: David Daney<david.daney@cavium.com>

WBR, Sergei

