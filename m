Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2EJK4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:56:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50861 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260Ab2EJK4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:56:40 -0400
Message-ID: <1336647368.2527.104.camel@twins>
Subject: Re: [PATCH 2/9] perf: Allow pmu to choose cpu on which to install
 event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 12:56:08 +0200
In-Reply-To: <4FAB38FF.4050203@linux.vnet.ibm.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-3-git-send-email-zheng.z.yan@intel.com>
	 <4FAA10FB.1030008@linux.vnet.ibm.com> <4FAB1548.6050806@intel.com>
	 <4FAB38FF.4050203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 09:11 +0530, Anshuman Khandual wrote:
> 
> Agreed. So here the get_online_cpus()/put_online_cpus() pair solves an
> existing problem. Could you please
> put an additional statement explaining this in the patch
> documentation. Thank you. 

No, make it a separate patch. If a patch does two separate things its
doing it wrong ;-)
