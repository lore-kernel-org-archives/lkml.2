Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0CVQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:16:26 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:47362 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751421Ab0CVQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:16:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NlTnFihDMqwIy+Kbg/IbH9zEz6XiU0k/fM0oXL2Js4cjU5nFh8DgctTR/ntHNfMm90cza1Z3NZaB5tfaRwOvsABsOu27bFaDA/FAidAvIJdxBVlHX6Yg+323xgCi6LFF;
Date: Mon, 22 Mar 2010 09:16:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 19/20] x86/pci: ioh new version read all at same time
Message-ID: <20100322091620.5aebf353@jbarnes-piketon>
In-Reply-To: <1269155601-18247-20-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
	<1269155601-18247-20-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010 00:13:20 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> also it will add back default range to legacy IOH
> 

This patch is a bit short on details.  Are we fixing a real bug here
that _CRS fails to cover?  Or is it just for debug purposes?

-- 
Jesse Barnes, Intel Open Source Technology Center
