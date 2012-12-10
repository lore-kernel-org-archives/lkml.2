Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2LJRCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:02:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42046 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2LJRCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:02:42 -0500
Message-ID: <50C615A3.8090400@zytor.com>
Date: Mon, 10 Dec 2012 09:02:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: TIP tree's master branch failed to boot up
References: <50C56A13.9040604@linux.vnet.ibm.com>
In-Reply-To: <50C56A13.9040604@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2012 08:50 PM, Michael Wang wrote:
> Hi, Folks
>
> I'm testing with the latest tip tree's master branch 3.7.0-rc8 and
> failed to boot up my server, it's hung at very beginning and I could not
> catch any useful log, is there any one else got this problem or I'm the
> only one?.
>
> Regards,
> Michael Wang
>

32 or 64 bits?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

