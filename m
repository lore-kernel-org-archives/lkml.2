Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256Ab2CNFf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:35:56 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47677 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2CNFfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:35:51 -0400
Message-ID: <4F602E2E.8030008@in.ibm.com>
Date: Wed, 14 Mar 2012 11:05:42 +0530
From: "M. Mohan Kumar" <mohan@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [V9fs-developer] 9p: BUG: unable to handle kernel paging request
 at ffff880035698000
References: <1329841429.10124.38.camel@lappy>
In-Reply-To: <1329841429.10124.38.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12031405-2674-0000-0000-000003AD3477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 09:53 PM, Sasha Levin wrote:
> Hi,
>
> I was using the KVM tool for tests with trinity on top of a virtio-9p filesystem, and started seeing the BUGs below when I've put some pressure on the 9p fs (not much, just started writing the logs from trinity to a 9p fs).
Hi Sasha,

You mentioned about testing with trinity, Where can I find this trinity 
? Is is some test suite ? Were you running 9p as root?

Which kernel version you were using? Is this bug still reproducible?

