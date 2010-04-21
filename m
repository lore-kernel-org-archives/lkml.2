Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0DUUrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:47:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42036 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab0DUUrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:47:09 -0400
Message-ID: <4BCF6425.7040908@zytor.com>
Date: Wed, 21 Apr 2010 13:46:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/5] x86, cacheinfo: Make L3 cache info per node
References: <1271349663-16670-1-git-send-email-bp@amd64.org> <1271349663-16670-5-git-send-email-bp@amd64.org>
In-Reply-To: <1271349663-16670-5-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 09:41 AM, Borislav Petkov wrote:
> +
> +/* max 8 nodes on a system */
> +static struct amd_l3_cache * __cpuinitdata l3_caches[8];
> +

This makes me very nervous.  Where does this limit come from?  It
appears completely arbitrary and seems like begging for problems in the
future.

	-hpa
