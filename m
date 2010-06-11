Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab0FKUP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:15:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52293 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab0FKUP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:15:57 -0400
Message-ID: <4C129968.9070502@zytor.com>
Date: Fri, 11 Jun 2010 13:15:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AMD errata checking framework
References: <1276262713-26864-1-git-send-email-hans.rosenfeld@amd.com>
In-Reply-To: <1276262713-26864-1-git-send-email-hans.rosenfeld@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 06:25 AM, Hans Rosenfeld wrote:
> +		if (static_cpu_has(X86_FEATURE_OSVW) && 

static_cpu_has() is only well-defined for code that is only executed
after alternatives execution; that would not seem to be the case for
this code.

	-hpa
