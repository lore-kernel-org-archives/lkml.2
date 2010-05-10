Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0EJRNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:13:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:38397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0EJRM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:12:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,363,1270450800"; 
   d="scan'208";a="797076157"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Jeff Squyres'" <jsquyres@cisco.com>,
       "Eric B Munson" <ebmunson@us.ibm.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-rdma@vger.kernel.org>, <linux-mm@kvack.org>, <rolandd@cisco.com>,
       <peterz@infradead.org>, <mingo@elte.hu>, <pavel@ucw.cz>,
       <randy.dunlap@oracle.com>
References: <1271943493-12120-1-git-send-email-ebmunson@us.ibm.com> <01C0A6AB-E4B6-4B56-AFAE-52952D152110@cisco.com>
Subject: RE: [PATCH] ummunotify: Userspace support for MMU notifications V2
Date: Mon, 10 May 2010 10:12:56 -0700
Message-ID: <56643C62C30044F0A734365A5274C821@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acrt3RQCVxEQbTOVRfOrwfFK2Z+gggChOphw
In-Reply-To: <01C0A6AB-E4B6-4B56-AFAE-52952D152110@cisco.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
>> and follow-up messages, libraries using RDMA would like to track
>> precisely when application code changes memory mapping via free(),
>> munmap(), etc.  Current pure-userspace solutions using malloc hooks
>> and other tricks are not robust, and the feeling among experts is that
>> the issue is unfixable without kernel help.
>
>Sorry for not replying earlier -- just to throw in my $0.02 here: the MPI
>community is *very interested* in having this stuff in upstream kernels.  It
>solves a fairly major problem for us.
>
>Open MPI (www.open-mpi.org) is ready to pretty much immediately take advantage
>of these capabilities.  The code to use ummunotify is in a Mercurial branch;
>we're only waiting for ummunotify to go upstream before committing our support
>for it to our main SVN development trunk.

Intel's MPI team has examined this proposal as well and would also like to see
this merged upstream.  It is helpful implementing MPI over RDMA devices.

- Sean

