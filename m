Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1CaFcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:32:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab1CaFcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:32:12 -0400
Date: Wed, 30 Mar 2011 22:32:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Message-Id: <20110330223231.e1f149eb.akpm@linux-foundation.org>
In-Reply-To: <20110331052703.GJ2879@balbir.in.ibm.com>
References: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
	<20110330163607.0984b831.akpm@linux-foundation.org>
	<20110331052703.GJ2879@balbir.in.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 10:57:03 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [2011-03-30 16:36:07]:
> 
> > On Wed, 30 Mar 2011 11:00:26 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Data from the previous patchsets can be found at
> > > https://lkml.org/lkml/2010/11/30/79
> > 
> > It would be nice if the data for the current patchset was present in
> > the current patchset's changelog!
> >
> 
> Sure, since there were no major changes, I put in a URL. The main
> change was the documentation update. 

Well some poor schmuck has to copy and paste the data into the
changelog so it's still there in five years time.  It's better to carry
this info around in the patch's own metedata, and to maintain
and update it.

