Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab2FSCEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:04:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47559 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2FSCEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:04:41 -0400
Message-ID: <4FDFDE15.8020109@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 10:04:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 6/9] KVM: MMU: fast path of handling guest page fault
References: <4FC470C7.5040700@linux.vnet.ibm.com> <4FC471B8.3070204@linux.vnet.ibm.com> <20120613224002.GE19290@amt.cnet> <4FD953BE.6020200@linux.vnet.ibm.com> <20120618193257.GB2697@amt.cnet>
In-Reply-To: <20120618193257.GB2697@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061815-6102-0000-0000-000001B7087D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:32 AM, Marcelo Tosatti wrote:

 
> Ok, if you/Avi want to avoid an atomic read-and-update, please
> introduce it later an as optimization patch.


Good to me, let's discus it in the separate patch. Thank you, Marcelo!

