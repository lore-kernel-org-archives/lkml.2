Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2BAPm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:42:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35613 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2BAPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:42:55 -0500
Date: Thu, 2 Feb 2012 00:42:49 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
Message-Id: <20120202004249.adb9954c45225383510b6994@gmail.com>
In-Reply-To: <20120201134347.GA18998@amt.cnet>
References: <1328016724.2446.229.camel@twins>
	<4F27F0E6.1040309@redhat.com>
	<1328017807.2446.230.camel@twins>
	<20120131222447.GH2391@linux.vnet.ibm.com>
	<1328091749.2760.34.camel@laptop>
	<4F29178A.1090306@redhat.com>
	<4F2918D5.4050104@redhat.com>
	<4F291B56.30600@oss.ntt.co.jp>
	<4F291B92.8070402@redhat.com>
	<20120201134347.GA18998@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 11:43:47 -0200
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> > > I can show you some performance numbers, this weekend, if you like.
> > 
> > That'll be great, numbers are better than speculation.
> 
>   get dirty log:    5634134 ns for     262144 dirty pages
> 
> 5ms (for the entire operation).
> 

I have mixed my personal patch series and Avi's comments, and ...

I am now getting really good improvements for every number of dirty pages.
(might be a dream, so checking now ... will soon report)

	Takuya
