Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2BAHEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:04:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51622 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2BAHEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:04:11 -0500
Message-ID: <4F28E48D.3040505@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 15:06:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 4/6] netprio_cgroup: use IS_ENABLED() and family
References: <4F28E1D1.900@cn.fujitsu.com>	<4F28E203.10502@cn.fujitsu.com> <20120201.015954.2098592611164231843.davem@davemloft.net>
In-Reply-To: <20120201.015954.2098592611164231843.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 15:02:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 15:02:47,
	Serialize complete at 2012-02-01 15:02:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14:59, David Miller wrote:
> 
> Do not mix genuine bug fixes and cleanups.
> 
> Otherwise I cannot apply your bug fixes to the 'net' tree.
> 
> Seperate things out, submit only pure bug fixes first, then
> later once those changes propagate you can submit the cleanups.
> 

I did seperate them out, so the first three patches are fixes,
and others are cleanups. I can resend cleanup patches once
fixes hit mainline.
