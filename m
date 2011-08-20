Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1HTCBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 22:01:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41116 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1HTCBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 22:01:49 -0400
Date: Sat, 20 Aug 2011 03:01:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jamie Lokier <jamie@shareable.org>, Sylvain Rochet <gradator@gradator.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: PROBLEM: 2.6.35.7 to 3.0 Inotify events missing
Message-ID: <20110820020147.GE2203@ZenIV.linux.org.uk>
References: <20101018223540.GA20730@gradator.net>
 <20110819230344.GA24784@gradator.net>
 <20110819233756.GI11512@jl-vm1.vm.bytemark.co.uk>
 <20110820012943.GD2203@ZenIV.linux.org.uk>
 <20110819184311.b094d6b7.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819184311.b094d6b7.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 06:43:11PM -0700, Randy Dunlap wrote:

> What do you suggest as a functioning alternative to inotify?

Depends on what particular (ab)use do you have in mind...
