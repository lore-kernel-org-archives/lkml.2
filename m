Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0IJUYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:24:17 -0400
Received: from borg.org ([64.105.205.123]:49505 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0IJUYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:24:16 -0400
X-Greylist: delayed 1793 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Sep 2010 16:24:16 EDT
Message-ID: <4C8A8CE8.90600@borg.org>
Date: Fri, 10 Sep 2010 15:54:16 -0400
From: Kent Borg <kentborg@borg.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: git-p4 
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a git-p4 question: I work in a Perforce shop and am doing Linux
kernel work, I need to share that work with colleagues who see the world
as a Perforce place.  The kernel I have came from Linus' tree and has a
lot of history.  When I try to do my first a "git p4 submit" it chokes
as it looks back in the entire git history until it fails looking for
the ancestor of the first commit (linux-2.6.12-rc2!), I think it is
looking for the last time it did a git-p4 submit so it knows how far
back to go--but it has never done a submit in this new relationship
between p4 and git.  There is plenty of git history that is not
reflected in p4, and I don't want it in p4, I just want new work in p4.

I fear that git-p4 is for git people to contribute to bits natively
p4-homed code, not this case where the code is natively git-homed code
and it is the p4 people who will be contributing bits. 

My attempt at a work around was this:

 - create a director on the p4 side, and from the p4 side submit the
files that match my latest git submit.

 - sync with git-p4

 - try to submit a file with git-p4...and that fails as it runs all the
way back through the history.  (Thank goodness it didn't succeed in
submitting kernel activity since 2005!)


I was hoping I could merge the p4/master with master to force a stopping
point in the git-p4 submit, but that doesn't work, it is searching
through git history to find the stopping point.  What might I put in the
git history to force the stop (or maybe make a change to git-p4 to help
my plight along)?


Thanks,

-kb, the Kent who has always hated Perforce, alas.

