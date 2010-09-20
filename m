Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0ITXEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:04:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0ITXD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:03:59 -0400
Date: Mon, 20 Sep 2010 17:17:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: fix the description of kvm-amd.nested in
 documentation
Message-ID: <20100920201720.GA6684@amt.cnet>
References: <4C976CCD.4030406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C976CCD.4030406@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 10:16:45PM +0800, Xiao Guangrong wrote:
> The default state of 'kvm-amd.nested' is enabled now, so fix the documentation
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  Documentation/kernel-parameters.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied both, thanks.

