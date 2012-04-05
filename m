Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2DEQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:14:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19948 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2DEQOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:14:23 -0400
Message-ID: <4F7DC4CC.9080502@parallels.com>
Date: Thu, 05 Apr 2012 20:14:04 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: kernel BUG at include/net/netns/generic.h:41
References: <20120328002346.GB3077@redhat.com> <20120402172600.GA3728@redhat.com> <1333390230.13718.34.camel@lade.trondhjem.org> <4F7DC37F.7090404@parallels.com> <20120405161241.GA23658@redhat.com>
In-Reply-To: <20120405161241.GA23658@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.04.2012 20:12, Dave Jones пишет:
> On Thu, Apr 05, 2012 at 08:08:31PM +0400, Stanislav Kinsbursky wrote:
>
>   >  So, there are few questions to you, Dave:
>   >  1) can this happen (PipeFS mount attempt before SUNPRC module insertion has
>   >  returned any value) in your case?
>
> I don't know enough of what systemd is doing to answer this.
>
>   >  2) how often do you experience this problem? Not every boot, I suppose?
>   >  3) And is it easy for you to reproduce?
>
> It happens most the time, but not every time.
>

Ok, I'll send the patch soon.
Hope, it will help.

-- 
Best regards,
Stanislav Kinsbursky
