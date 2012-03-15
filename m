Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab2COOH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:07:29 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39956 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2COOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:07:26 -0400
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: Dave Jones <davej@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] 9p: BUG: unable to handle kernel paging request at ffff880035698000
In-Reply-To: <20120314142301.GA2371@redhat.com>
References: <1329841429.10124.38.camel@lappy> <4F602E2E.8030008@in.ibm.com> <20120314142301.GA2371@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Thu, 15 Mar 2012 19:37:12 +0530
Message-ID: <87ehsurm9b.fsf@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031514-2674-0000-0000-000003B46920
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dave & Sasha, I will try with trinity and update.

On Wed, 14 Mar 2012 10:23:01 -0400, Dave Jones <davej@redhat.com> wrote:
> On Wed, Mar 14, 2012 at 11:05:42AM +0530, M. Mohan Kumar wrote:
>  > On 02/21/2012 09:53 PM, Sasha Levin wrote:
>  > > Hi,
>  > >
>  > > I was using the KVM tool for tests with trinity on top of a virtio-9p filesystem, and started seeing the BUGs below when I've put some pressure on the 9p fs (not much, just started writing the logs from trinity to a 9p fs).
>  > Hi Sasha,
>  > 
>  > You mentioned about testing with trinity, Where can I find this trinity 
>  > ? Is is some test suite ?
> 
> git://git.codemonkey.org.uk/trinity
> 
> 	Dave
> 

