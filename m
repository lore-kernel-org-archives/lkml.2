Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab1EGIHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:07:15 -0400
Received: from yop.chewa.net ([91.121.105.214]:41593 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab1EGIHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:07:08 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 04:07:08 EDT
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/7] ns: Introduce the setns syscall
Date: Sat, 7 May 2011 11:01:08 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.38-2-686; KDE/4.4.5; i686; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org> <1304735101-1824-1-git-send-email-ebiederm@xmission.com> <1304735101-1824-2-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1304735101-1824-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105071101.10950.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 7 mai 2011 05:24:56 Eric W. Biederman, vous avez écrit :
> Pieces of this puzzle can also be solved by instead of
> coming up with a general purpose system call coming up
> with targed system calls perhaps socketat that solve
> a subset of the larger problem.  Overall that appears
> to be more work for less reward.

socketat() is still required for multithreaded namespace-aware userspace, I 
believe.

-- 
Rémi Denis-Courmont
http://www.remlab.info/
http://fi.linkedin.com/in/remidenis
