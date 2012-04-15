Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2DOWbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:31:48 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:34055 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2DOWbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:31:19 -0400
Message-ID: <1334529077.2092.1.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org
Date: Mon, 16 Apr 2012 08:31:17 +1000
In-Reply-To: <201204160008.41104.rjw@sisk.pl>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <4F8AC34F.1050702@debian.org> <201204160008.41104.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 00:08 +0200, Rafael J. Wysocki wrote:
> > Signed-off-by: Per Olofsson <pelle@debian.org>
> 
> Why signed-off? 

Per contributed significantly to the development of the patch. In fact,
it was Per who noticed what the problem with number of free pages
calculation during hibernation actually was.

-- 
Bojan

