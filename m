Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab2DKMPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:15:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65005 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2DKMPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:15:19 -0400
Date: Wed, 11 Apr 2012 21:15:14 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-Id: <20120411211514.35db29c11460516e604059b6@gmail.com>
In-Reply-To: <4F842074.1050108@linux.vnet.ibm.com>
References: <4F742951.7080003@linux.vnet.ibm.com>
	<4F82E04E.6000900@redhat.com>
	<20120409175829.GB21894@amt.cnet>
	<4F8329D3.7000605@gmail.com>
	<20120409194614.GB23053@amt.cnet>
	<4F840DD2.3090101@redhat.com>
	<20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
	<4F842074.1050108@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 19:58:44 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> No, i do not really agree with that.
> 
> We really can get great benefit from O(1) especially if lockless write-protect
> is introduced for O(1), live migration is very useful for cloud computing
> architecture to balance the overload on all nodes.

Recently, you said to me that you were not familiar with live migration.
Actually you did not know the basics of pre-copy live migration.

I know live migration better than you because NTT has Kemari and it uses
live migration infrastructure.  My work is originated from the data
I got during profiling Kemari.

SRCU-less dirty logging was also motivated by the pressures from scheduler
developers.  Everything was really needed.


Have you ever used live migration for real service?

I cannot say whether O(1) is OK with me without any real background.

	Takuya
