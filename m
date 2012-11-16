Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2KPP46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:56:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2KPP44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:56:56 -0500
Message-ID: <50A66236.1070706@zytor.com>
Date: Fri, 16 Nov 2012 07:56:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 2/9] x86: Add macro for 64bit entry for bzImage
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-3-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353055989-31939-3-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 12:53 AM, Yinghai Lu wrote:
> will use it with bzImage header.

This isn't really a decent description.  The subject line should stand
alone from the patch comment.  Think of it as a newspaper headline
versus the newspaper article.

	-hpa

