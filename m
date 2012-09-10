Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2IJRNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:13:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:46828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2IJRNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:13:44 -0400
Message-ID: <1347297219.2124.43.camel@twins>
Subject: Re: [PATCH 0/3] perf: precise mode and exclude_guest
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Mon, 10 Sep 2012 19:13:39 +0200
In-Reply-To: <504E1CD0.8040306@gmail.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
	 <1347296241.2124.32.camel@twins> <504E1CD0.8040306@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 11:01 -0600, David Ahern wrote:
> On 9/10/12 10:57 AM, Peter Zijlstra wrote:
> > On Mon, 2012-09-10 at 10:40 -0600, David Ahern wrote:
> >> Hopefully thi wraps up the precise mode-exclude_guest dependency.
> >> I'm sure someone will let me know if I screwed up the attribution
> >> in the second patch.
> >
> >
> > I'll wait with applying until we have the IBS stuff sorted, other than
> > that, thanks for collecting this..
> >
> 
> Robert recently confirmed that this series should not have an impact on 
> AMD as it currently stands -- exclude attributes are ignored. And then 
> his patch to require they be unset works fine with the first patch in 
> this set because of the existing EINVAL fallback handling in perf-record 
> and perf-top.
> 
> Did you have something else in mind that needs to be done?

Ah, no, just hadn't integrated all this various data yet. There seems to
be a lag between reading stuff and actually knowing it :/

OK, let me go through all this once again.
