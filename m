Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2FUB4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:56:36 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:53532 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab2FUB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:56:34 -0400
Date: Thu, 21 Jun 2012 10:56:24 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
Message-Id: <20120621105624.4b43d6f4.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4FE27D55.4040805@linux.vnet.ibm.com>
References: <4FE1822D.8010002@linux.vnet.ibm.com>
	<4FE1825B.1030402@linux.vnet.ibm.com>
	<20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp>
	<4FE193AA.8010801@linux.vnet.ibm.com>
	<20120620215653.15930f3467bc13748d548b0d@gmail.com>
	<4FE1CE43.9080203@linux.vnet.ibm.com>
	<20120620231112.440df9ae19c1aca36100b746@gmail.com>
	<4FE27D55.4040805@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 09:48:05 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> > We can change the debug message later if needed.

> Actually, i am going to use tracepoint instead of
> these debug code.

That's very nice!

Then, please change the trace log to correspond to the
new spte_write_protect name at that time.

Thank you, Xiao.

	Takuya
