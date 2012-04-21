Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2DUBKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:10:55 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34892 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2DUBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:10:54 -0400
Date: Sat, 21 Apr 2012 10:10:49 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] KVM: MMU: abstract spte write-protect
Message-Id: <20120421101049.421a744ba5898b6173159cb4@gmail.com>
In-Reply-To: <20120420213319.GA13817@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
	<4F911BAB.6000206@linux.vnet.ibm.com>
	<20120420213319.GA13817@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 18:33:19 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> It is preferable to remove all large sptes including read-only ones, the
> current behaviour, then to verify that no read->write transition can
> occur in fault paths (fault paths which are increasing in number).
> 

I think we should use separate function than spte_write_protect() for
the large case.

	Takuya
