Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2FUBsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:48:16 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55818 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab2FUBsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:48:14 -0400
Message-ID: <4FE27D55.4040805@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 09:48:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
References: <4FE1822D.8010002@linux.vnet.ibm.com> <4FE1825B.1030402@linux.vnet.ibm.com> <20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp> <4FE193AA.8010801@linux.vnet.ibm.com> <20120620215653.15930f3467bc13748d548b0d@gmail.com> <4FE1CE43.9080203@linux.vnet.ibm.com> <20120620231112.440df9ae19c1aca36100b746@gmail.com>
In-Reply-To: <20120620231112.440df9ae19c1aca36100b746@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062101-9574-0000-0000-0000033E8220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 10:11 PM, Takuya Yoshikawa wrote:


> We can change the debug message later if needed.


Actually, i am going to use tracepoint instead of
these debug code.

