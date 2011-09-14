Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab1INUWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:22:45 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39267 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab1INUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:22:44 -0400
Date: Wed, 14 Sep 2011 22:22:42 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stupid git question
Message-ID: <20110914202242.GA1635@x4.trippels.de>
References: <20110914201912.GA29635@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914201912.GA29635@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.09.14 at 15:19 -0500, Bob Tracy wrote:
> Subject says a mouthful, but I digress...
> 
> Pointed "git" at Linus' github.com repository to pull the "-rc6"
> changes (git pull <repo_url>).  Seems to have worked, except I received
> no updated tags: the latest tag in my local repo copy is "v3.1-rc4".
> 
> Is this an expected consequence of doing the initial clone operation
> from one repo, and then pulling updates from another that, in theory, is
> identical to the first?  If so, is there an officially sanctioned method
> of switching repositories that doesn't require blowing away the local
> copy and doing another "git clone"?

git fetch --tags https://github.com/torvalds/linux.git

is what you need.

-- 
Markus
