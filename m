Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab0EGGja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:39:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1963 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0EGGj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:39:29 -0400
Subject: Re: [PATCH] get_maintainer.pl: ignore non-maintainer tags
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1273214095-23396-1-git-send-email-florian@mickler.org>
References: <1273179148.1537.145.camel@Joe-Laptop.home>
	 <1273214095-23396-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 23:39:26 -0700
Message-ID: <1273214367.1540.21.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 08:34 +0200, florian@mickler.org wrote:
> Using --git to determine who to send a patch to, it is not
> reasonable to include people that only reported an issue or tested a
> patch.

I think this is a questionable assumption.

People that test or otherwise sign a patch are also good
candidates to review new patches.

cheers, Joe

