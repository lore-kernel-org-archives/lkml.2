Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab0D3TOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:14:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab0D3Q6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:40 -0400
Message-ID: <4BDA8DCA.9010401@kernel.org>
Date: Fri, 30 Apr 2010 09:59:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org> <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz> <20100430075510.GA21105@elte.hu>
In-Reply-To: <20100430075510.GA21105@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 07:59:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/30/2010 09:55 AM, Ingo Molnar wrote:
> A similar patch was sent a few weeks ago, it was objected to and rejected - 
> the copyright character was used for legal reasons.

Paul says that "Copyright" is enough, so what are the legal reasons?

Also, if the copyright designator absolutely has to be there, then can
it be in UTF-8 at least?

Thanks.

-- 
tejun
