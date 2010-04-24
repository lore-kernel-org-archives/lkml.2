Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DXJMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 05:12:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44326 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0DXJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 05:12:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BD2B5EC.4020808@s5r6.in-berlin.de>
Date: Sat, 24 Apr 2010 11:12:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: tytso@mit.edu
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: -stable rules: upstream commit ID
 requirement reworded
References: <20100422222928.GA3268@kroah.com> <1271976016-3584-1-git-send-email-gregkh@suse.de> <20100424020253.GP14986@thunk.org>
In-Reply-To: <20100424020253.GP14986@thunk.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tytso@mit.edu wrote:
> On Thu, Apr 22, 2010 at 03:40:14PM -0700, Greg Kroah-Hartman wrote:
>> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>>
>> It is a hard requirement to include the upstream commit ID in the
>> changelog of a -stable submission, not just a courtesy to the stable
>> team.  This concerns only mail submission though, which is no longer
>> the only way into stable.  (Also, fix a double "the".)
> 
> I find the upstream commit ID to be highly useful when looking at
> commits in the stable tree.  So it would be nice IMHO if we could
> enforce this requirement regardless of whether the submission path is
> via e-mail or git.

In the semi-automatic submission path via git --- i.e. of commits which
feature a Cc: stable@kernel.org line in the changelog when they show up
in Linus' tree --- the upstream commit ID is not known to the submitter
at the time of submission.  Apparently Greg's scripts modify the
changelogs respectively when he cherry-picks from linux-2.6.git, so the
requirement is also always fulfilled with this alternative submission path.

E.g. as in http://lkml.org/lkml/2010/4/22/294 which was apparently
submitted the semi-automatic way, via
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=44fef22416886a04d432043f741a6faf2c6ffefd
-- 
Stefan Richter
-=====-==-=- -=-- ==---
http://arcgraph.de/sr/
