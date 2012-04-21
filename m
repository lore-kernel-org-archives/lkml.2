Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2DUBDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:03:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42685 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2DUBDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:03:17 -0400
Date: Sat, 21 Apr 2012 10:03:12 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/16] KVM: MMU: introduce for_each_pte_list_spte
Message-Id: <20120421100312.dd3fbb9bd727cc27d7800ccd@gmail.com>
In-Reply-To: <4F8E915E.2010705@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FC19.8080404@linux.vnet.ibm.com>
	<20120414114422.e3fe6e2abbfdcce61e6f69c8@gmail.com>
	<4F8B93B9.2030801@linux.vnet.ibm.com>
	<20120417234731.a19f270d5701b11ce95d13d4@gmail.com>
	<4F8E915E.2010705@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012 18:03:10 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> By the way, what is the case did you test? ept = 1 ?

Yes!

I am not worrying about without-EPT/NPT-migration.

	Takuya
