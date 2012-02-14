Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132Ab2BNNwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:52:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab2BNNwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:52:24 -0500
Message-ID: <1329227537.2293.1.camel@twins>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Venki Pallipadi <venki@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Feb 2012 14:52:17 +0100
In-Reply-To: <20120213053410.GB24636@zhy>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	 <1328901567.25989.51.camel@laptop>
	 <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
	 <20120213053410.GB24636@zhy>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 13:34 +0800, Yong Zhang wrote:
> Yeah, most of the things could be shared. Such as the added logic when
> return from idle and the hooks into ttwu_queue_remote() and
> generic_exec_single().
> 

The thing is, those last two should not have hooks. Nor am I convinced
anything outside of the arch idle loop should have any.


