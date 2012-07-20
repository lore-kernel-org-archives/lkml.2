Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2GTQm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:42:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2GTQm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:42:56 -0400
Message-ID: <1342802550.2583.12.camel@twins>
Subject: Re: [PATCH 0/5] cpusets: dynamical scheduler domain flags
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, paul@paulmenage.org
Date: Fri, 20 Jul 2012 18:42:30 +0200
In-Reply-To: <50052A78.6000407@linux.vnet.ibm.com>
References: <50052A78.6000407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 17:03 +0800, Michael Wang wrote:
> This patch set provide a way for user to dynamically configure the scheduler
> domain flags, which usually to be static. 

NAK.. you don't get to expose all this nonsense in a 'stable' ABI.

You shouldn't need to prod at them to begin with.
