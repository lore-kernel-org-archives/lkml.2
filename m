Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab1JFWYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:24:03 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36997 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1JFWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:24:01 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Date: Fri, 07 Oct 2011 09:23:58 +1100
In-Reply-To: <201110062045.48689.rjw@sisk.pl>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl>
	 <201110062045.48689.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317939838.1961.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 20:45 +0200, Rafael J. Wysocki wrote:

> > I get a kernel panic on a test box using a x86_64 kernel with this patch
> > applied.
> 
> The panic happens during late resume, when trying to switch to the hibernated
> kernel.

Do you have a dump by any chance? Is it always at the same spot or
random?

-- 
Bojan

