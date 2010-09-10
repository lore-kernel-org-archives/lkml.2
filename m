Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0IJVxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 17:53:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42242 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0IJVxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 17:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kij5Uf70MPHFFhCQQW2ekzo0qNcnrX4HYdArNcfgkLEanZPoViR3A14W1Jikp06lda
         oM3wsy5jUAj1xAnrXK5bWfblIfKBeoeC4b9E6ZDSLN5yNFoJ8qAFGx3HfOiwOJVf9rE9
         knoXzvb9Il7vkJoA33n/8QA9aE4WX+FUagwZ4=
Date: Fri, 10 Sep 2010 23:53:23 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Kent Borg <kentborg@borg.org>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: git-p4
Message-ID: <20100910235323.773d2c5b@varda>
In-Reply-To: <4C8A8CE8.90600@borg.org>
References: <4C8A8CE8.90600@borg.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 10 Sep 2010 15:54:16 -0400
Kent Borg <kentborg@borg.org> escribió:

 [ CCing git mailing list. Looks like a better place to ask this question]

> I have a git-p4 question: I work in a Perforce shop and am doing Linux
> kernel work, I need to share that work with colleagues who see the world
> as a Perforce place.  The kernel I have came from Linus' tree and has a
> lot of history.  When I try to do my first a "git p4 submit" it chokes
> as it looks back in the entire git history until it fails looking for
> the ancestor of the first commit (linux-2.6.12-rc2!), I think it is
> looking for the last time it did a git-p4 submit so it knows how far
> back to go--but it has never done a submit in this new relationship
> between p4 and git.  There is plenty of git history that is not
> reflected in p4, and I don't want it in p4, I just want new work in p4.
> 
> I fear that git-p4 is for git people to contribute to bits natively
> p4-homed code, not this case where the code is natively git-homed code
> and it is the p4 people who will be contributing bits. 
> 
> My attempt at a work around was this:
> 
>  - create a director on the p4 side, and from the p4 side submit the
> files that match my latest git submit.
> 
>  - sync with git-p4
> 
>  - try to submit a file with git-p4...and that fails as it runs all the
> way back through the history.  (Thank goodness it didn't succeed in
> submitting kernel activity since 2005!)
> 
> 
> I was hoping I could merge the p4/master with master to force a stopping
> point in the git-p4 submit, but that doesn't work, it is searching
> through git history to find the stopping point.  What might I put in the
> git history to force the stop (or maybe make a change to git-p4 to help
> my plight along)?
> 
> 
> Thanks,
> 
> -kb, the Kent who has always hated Perforce, alas.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
