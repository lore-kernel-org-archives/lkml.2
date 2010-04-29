Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab0D3S4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:56:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758425Ab0D3RGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:06:50 -0400
Message-ID: <4BD91A94.8030406@kernel.org>
Date: Thu, 29 Apr 2010 07:35:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mackerras <paulus@au1.ibm.com>
CC: Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org> <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz> <20100429045709.GA27842@drongo>
In-Reply-To: <20100429045709.GA27842@drongo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 05:35:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/29/2010 06:57 AM, Paul Mackerras wrote:
> I don't want "(C)" in there because our lawyers tell me that it is
> legally meaningless, but "Copyright" on its own is good enough.

The other lines contain the (C) so if it's not harming, let's leave it
like that.  It might be legally meaningless but is textually /
aesthetically meaningful to your fellow coders.  :-)

Thanks.

-- 
tejun
