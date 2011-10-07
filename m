Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab1JGDU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:20:29 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:52416 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab1JGDU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:20:28 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Date: Fri, 07 Oct 2011 14:20:26 +1100
In-Reply-To: <201110062045.48689.rjw@sisk.pl>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl>
	 <201110062045.48689.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317957626.2008.2.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 20:45 +0200, Rafael J. Wysocki wrote:
> > I get a kernel panic on a test box using a x86_64 kernel with this
> patch applied.
> 
> The panic happens during late resume, when trying to switch to the
> hibernated kernel. 

I'm working on a version of the patch that will produce a SHA1 checksum
of the image pages on save/load. This will then eliminate problems
related to pages not being saved/loaded correctly by threads etc.

I'll send you that when I test it. If that still panics your kernel
after the checksums have been verified, then we have another problem
somewhere.

-- 
Bojan

