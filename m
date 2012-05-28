Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2E1NB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:01:27 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44425 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2E1NBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:01:25 -0400
Message-ID: <4FC376CD.80902@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 20:59:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: introduce readonly memory region
References: <4FBDFE52.5090902@linux.vnet.ibm.com> <4FBE2521.1050800@redhat.com> <4FBF471E.9080809@linux.vnet.ibm.com> <20120528072118.GE4369@redhat.com>
In-Reply-To: <20120528072118.GE4369@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052813-2674-0000-0000-000004B4ADE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 03:21 PM, Gleb Natapov wrote:

> On Fri, May 25, 2012 at 04:47:26PM +0800, Xiao Guangrong wrote:
>> By the way, a foolish question, what is ROMD?  i did not find any explanation
>> on google.
> This is memory region that behaves like ROM on read and like a device on
> write. IIRC some flash chips are like that.
> 


Got it, thank you, Gleb! :)

