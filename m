Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0DXJaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 05:30:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44395 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0DXJaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 05:30:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BD2BA28.3000109@s5r6.in-berlin.de>
Date: Sat, 24 Apr 2010 11:30:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: tytso@mit.edu
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: -stable rules: upstream commit ID
 requirement reworded
References: <20100422222928.GA3268@kroah.com> <1271976016-3584-1-git-send-email-gregkh@suse.de> <20100424020253.GP14986@thunk.org> <4BD2B5EC.4020808@s5r6.in-berlin.de>
In-Reply-To: <4BD2B5EC.4020808@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> tytso@mit.edu wrote:
>> I find the upstream commit ID to be highly useful when looking at
>> commits in the stable tree.  So it would be nice IMHO if we could
>> enforce this requirement regardless of whether the submission path is
>> via e-mail or git.
...
> Apparently Greg's scripts modify the
> changelogs respectively when he cherry-picks from linux-2.6.git, so the
> requirement is also always fulfilled with this alternative submission path.

Or do you mean submission directly from a developer's git tree to stable
via git pull by Greg?  Is this been done?  If yes, I suppose this comes
only from people who know very well how a stable patch is meant to look
like.  Nevertheless I could send another adjustment for
Documentation/stable_kernel_rules.txt if this is another actual
submission path.
-- 
Stefan Richter
-=====-==-=- -=-- ==---
http://arcgraph.de/sr/
