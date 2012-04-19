Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2DSGrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:47:10 -0400
Received: from mail.vyatta.com ([76.74.103.46]:40962 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab2DSGq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:46:57 -0400
Date: Wed, 18 Apr 2012 23:46:49 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Peter Huang(Peng)" <peter.huangpeng@huawei.com>
Cc: "'David S. Miller'" <davem@davemloft.net>, netdev@vger.kernel.org,
        ctrix+debianbugs@navynet.it, Eric Dumazet <eric.dumazet@gmail.com>,
        harry.majun@huawei.com, linux-kernel@vger.kernel.org,
        peter.huangpeng@gmail.com
Subject: Re: [PATCH v3] set fake_rtable's dst to NULL to avoid kernel Oops.
Message-ID: <20120418234649.0bcb3872@nehalam.linuxnetplumber.net>
In-Reply-To: <4F8F77F5.8020201@huawei.com>
References: <4F8F77F5.8020201@huawei.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 10:27:01 +0800
"Peter Huang(Peng)" <peter.huangpeng@huawei.com> wrote:

> When bridge is deleted before tap/vif device's delete, kernel may 
> encounter an oops because of NULL reference to fake_rtable's dst.
> Set fake_rtable's dst to NULL before sending packets out can solve this 
> problem.
> 
> v3 enrich commit header
> 
> v2 added a new flag DST_FAKE_RTABLE to dst_entry struct.
> 
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Peter Huang <peter.huangpeng@huawei.com>

I am okay with the contents of the patch but the formatting is all
botched. It adds bad indentation and whitespace, please run it
through checkpatch. 

