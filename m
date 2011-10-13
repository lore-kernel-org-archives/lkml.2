Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1JMVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:54:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1JMVyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:54:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Thu, 13 Oct 2011 23:57:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
References: <1317342456.1959.6.camel@shrek.rexursive.com> <201110132326.02041.rjw@sisk.pl> <1318542285.2081.1.camel@shrek.rexursive.com>
In-Reply-To: <1318542285.2081.1.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110132357.13555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 13, 2011, Bojan Smojver wrote:
> On Thu, 2011-10-13 at 23:26 +0200, Rafael J. Wysocki wrote:
> > If your system is 64-bit, then the patch below may help.
> 
> OK, I may try that on my ThinkPad.
> 
> Anyhow, you still getting panics as a direct result of my hibernation
> patch?

No, v11 doesn't panic for me any more, so I'm going to put it
back into linux-pm/linux-next.

Thanks,
Rafael
