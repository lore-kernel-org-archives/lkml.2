Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab2BMKGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:06:20 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53469 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2BMKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:06:18 -0500
Message-ID: <4F38E091.5070504@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 18:06:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com>
In-Reply-To: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021300-5140-0000-0000-000000BCE6BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 01:32 PM, David Ahern wrote:

> [sorry for the top post - you would think Android would have a better mail client]
> 
> If the first patch is needed then kvm-events will not work with older, unpatched kernels. That's a big limitation from a perf perpective.
> 


The first patch is only needed for code compilation, after kvm-events is
compiled, you can analyse any kernels. :)

