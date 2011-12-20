Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1LTLji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:39:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56593 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LTLjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:39:33 -0500
Message-ID: <1324381161.24621.53.camel@twins>
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 12:39:21 +0100
In-Reply-To: <1324380648.24621.49.camel@twins>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
	 <1324044159.18942.104.camel@twins> <1324044196.18942.105.camel@twins>
	 <20111220103154.GA1861@m.brq.redhat.com> <1324378070.24621.32.camel@twins>
	 <1324380648.24621.49.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 12:30 +0100, Peter Zijlstra wrote:
> event   config-0:7
> umask   config-8:15
> usr     config-16
> os      config-17
> edge    config-18
> any     config-21
> inv     config-23
> cmask   config-24:31
> 
> nhm-dmnd_data_rd        config1-0
> nhm-dmnd_rfo            config1-1
> nhm-dmnd_ifetch         config1-2
> ...
> 
> (the real syntax will likely be a little more complex in order to be
> able to express the various other architectures their raw input format). 

for instance AMD would need:

event	config-0:7,32-35
guest	config-40
host	config-41

(assuming you read that as a mask from LSB to MSB)

And I still haven't actually read how the P4 works so I can't help out
there.
