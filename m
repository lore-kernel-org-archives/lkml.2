Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2FZX60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:58:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab2FZX6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:58:25 -0400
Date: Tue, 26 Jun 2012 19:58:04 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Mackerras <paulus@samba.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [linux-pm] [PATCH -v4 6/6] fault-injection: add notifier error
 injection testing scripts
Message-ID: <20120626235804.GA7525@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Akinobu Mita <akinobu.mita@gmail.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Paul Mackerras <paulus@samba.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org
References: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
 <1340463502-15341-7-git-send-email-akinobu.mita@gmail.com>
 <20120626163147.93181e21.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626163147.93181e21.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 04:31:47PM -0700, Andrew Morton wrote:

 > My overall take on the fault-injection code is that there has been a
 > disappointing amount of uptake: I don't see many developers using them
 > for whitebox testing their stuff.  I guess this patchset addresses
 > that, in a way.

I added support for make-it-fail to my syscall fuzzer a while ago.
(if the file exists, the child processes set it before calling the fuzzed syscall).
I've not had a chance to really play with it, because I find enough problems
already even without it.

	Dave
