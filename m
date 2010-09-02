Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0IBKPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:15:06 -0400
Received: from thunk.org ([69.25.196.29]:41621 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0IBKPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:15:04 -0400
Date: Thu, 2 Sep 2010 04:39:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [Patch] ext4: avoid null dereference
Message-ID: <20100902083955.GC4930@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Wen Congyang <wency@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
References: <4C777C04.7080906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C777C04.7080906@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch, I've added it to the ext4 patch queue, with the
patch summary changed to "avoid null dereference in trace_ext4_mballoc_discard"

						- Ted

