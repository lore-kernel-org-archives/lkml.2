Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab2C2TJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:09:31 -0400
Received: from fifo99.com ([67.223.236.141]:57178 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2C2TJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:09:23 -0400
Date: Thu, 29 Mar 2012 12:09:23 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329190922.GG16476@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
 <20120329145055.GE13912@fifo99.com>
 <4F748CF6.4010205@am.sony.com>
 <20120329175209.GE16476@fifo99.com>
 <20120329195007.07d53db7@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329195007.07d53db7@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 07:50:07PM +0100, Alan Cox wrote:
> 
> The question is whether you are trying to record data for analysis in a
> hostile environment or you are trying to do useful debugging. If your
> apps are non hostile then PR_SET_NAME is actually useful in logging to
> split apart different executions of the same daemon.

True..
 
> The Android logger has no security model of any real kind so it's clearly
> about the debug side. In that case the PID lets you correlate with other
> logs, the comm data might be useful.

	Your right it doesn't have much in terms of security, but Tim is suggesting
that it is a hostile environment in need of what little security it has.

	If your logging on a hostile system then Android's logger and my shared
memory version are both wide open. However, that doesn't mean you could lock
both down in some way.

Daniel
