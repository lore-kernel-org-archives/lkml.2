Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0JNJNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:13:54 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58357 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0JNJNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:13:53 -0400
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <AANLkTin5uZdurFzJzzcHiEc6jGAt8bn9v1B0rvkUV1SB@mail.gmail.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075109.GC9893@in.ibm.com> <1287046650.29097.159.camel@twins>
	 <AANLkTin5uZdurFzJzzcHiEc6jGAt8bn9v1B0rvkUV1SB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 11:13:28 +0200
Message-ID: <1287047608.29097.170.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 02:07 -0700, Paul Turner wrote:
> Separate branch no? 

Right, /me goes get more morning juice..
