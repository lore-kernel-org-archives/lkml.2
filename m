Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab1JFRy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1JFRy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:54:27 -0400
Date: Thu, 6 Oct 2011 14:53:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
Message-ID: <20111006175333.GA3959@amt.cnet>
References: <4E7AF758.7060900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
> This patchset is against https://github.com/avikivity/kvm.git next branch.
> 
> In this version, some changes come from Avi's comments:
> - fix instruction retried for nested guest
> - skip write-flooding for the sp whose level is 1
> - rename some functions

Please rebase.

