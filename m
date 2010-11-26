Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0KZObo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:31:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0KZObn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:31:43 -0500
Date: Fri, 26 Nov 2010 12:29:07 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] KVM: MMU: fix forgot flush tlbs on sync_page path
Message-ID: <20101126142906.GA31573@amt.cnet>
References: <4CE63CF4.80502@cn.fujitsu.com>
 <4CEF0F48.8000202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEF0F48.8000202@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 09:37:12AM +0800, Xiao Guangrong wrote:
> Hi Avi, Marcelo,
> 
> What do you think of this patchset? Could you give me some comments please?
> 
> Thanks!

Applied, thanks.

