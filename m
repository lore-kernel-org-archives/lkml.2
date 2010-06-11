Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab0FKUOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab0FKUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:14:52 -0400
Message-ID: <4C129927.4060502@zytor.com>
Date: Fri, 11 Jun 2010 13:14:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AMD errata checking framework
References: <1276262713-26864-1-git-send-email-hans.rosenfeld@amd.com>
In-Reply-To: <1276262713-26864-1-git-send-email-hans.rosenfeld@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 06:25 AM, Hans Rosenfeld wrote:
> +
> +/*
> + * Check for the presence of an AMD erratum.
> + * Arguments are defined in processor.h for each known erratum.
> + */
> +bool cpu_has_amd_erratum(const struct cpuinfo_x86 *cpu, bool osvw, ...)
> +{

/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c: In
function ‘cpu_has_amd_erratum’:
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:635: error:
expected expression before ‘do’
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:636: error:
expected expression before ‘do’
/home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:632:
warning: unused variable ‘t’

Also, the use of divide and modulo when shifts and masks work are
generally frowned upon in Linux as a matter of style.

	-hpa
