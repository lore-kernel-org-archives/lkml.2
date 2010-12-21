Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0LUXXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:23:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46086 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab0LUXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:23:17 -0500
Message-ID: <4D11369E.1090003@zytor.com>
Date: Tue, 21 Dec 2010 15:22:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 01/10] xen: Make all reserved pages for the balloon be
 INVALID_P2M_ENTRY.
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-2-git-send-email-konrad.wilk@oracle.com> <4D1127FC.8060102@goop.org>
In-Reply-To: <4D1127FC.8060102@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 02:19 PM, Jeremy Fitzhardinge wrote:
> 
> Also, I'm not a fan of hiding real side-effectful code in a BUG_ON
> predicate.
> 

That's an understatement.  There are two schools of thought about what
that should mean if BUG_ON was suppressed at compile time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

