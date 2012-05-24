Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966195Ab2EXT6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:58:15 -0400
Received: from nm10.bullet.mail.ac4.yahoo.com ([98.139.52.207]:41579 "HELO
	nm10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966173Ab2EXT6A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:58:00 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2012 15:58:00 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 853623.23863.bm@omp1011.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UA4Uudo1+Ig7BUgUrst7j6gLeX2KZGEimMTenPDtkoecQCjjdbdYnSUljFGrbCDZ49as9GzKIjqUnSjYIgb0v9G+4fLBU2A21vGAzACs7dn30wG33YpchSnMtea1BokEWnAo5wEQDGa24pt7eYZh34sr0XhZjIMWCyyS9djX5KM=;
X-YMail-OSG: JV3FhJcVM1l9bFFlfkYAi0QVzqTMpuhKY6OzrL9Vkqo0L3e
 QaIRtUdlk4rL.C0KrLUFSM89DOvVT6Ysiapz.SDQXKKpZMpBMi13LPyuza5k
 GfbwgANvNtm2cPZnDnNibTQ.v93l.z8LPvX.T_oRfaRX7v5pu..psUwYY0ZV
 OVxsBB345jxjbdyA8oslfYG16FVWpV30_.TNRsGpH2G_2ysYbhia1zb9ovMy
 R_.HK4NLljrBAw0jJw0qBneByEy3GLYIAxitMl7p1bpIwb_UR6Z7cAiPRV7H
 1csOn1GKVnVWqQZR_FuRULbrcS.vDwNundB617fjH8JL67i9yyZST4U674tE
 7jLMwH6JpUjzYc0Eh647Rb1gpLqO52s7_09FYCQqx8iLt7VzxuINt6LxLS4T
 uHX8SnqzMPLcMlVxtQ1QF8mA7sf5CnlqbnFmUhbnIHOKN8WsiEEwVtbvkczb
 AySdMcqGFKeqY_8IrikJuun3lfFBEKnFgFJr.bMRKpsPBshS5gbiC
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.118.349524
Message-ID: <1337889128.10617.YahooMailClassic@web84515.mail.ne1.yahoo.com>
Date: Thu, 24 May 2012 12:52:08 -0700 (PDT)
From: kd6lvw@yahoo.com
Subject: Re: Mounting /proc w/ kernel 3.4.0 - "uid" parameter no longer valid?
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 5/24/12, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "D. Stussy" <spam+newsgroups@bde-arc.ampr.org> writes:
> > proc:  unrecognized mount option "uid=1" or missing value
> >
> > This works under 3.3.6 and earlier (I never tried 3.3.7).  It appears that the
> > "uid" mount option was removed.  WHY?  More importantly, where is this change
> > listed?  I didn't see it in the git log.
> >
> > This is really bad as I rebooted a remotely colocated server and since the
> > procfs is not mounted, I cannot log in via SSH to correct the problem.
> >
> > OK, so there's not that much point in changing the UID of the procfs files, but
> > I preferred to set their default ownership to a non-privileged user. 
> 
> There has never been a uid= option to /proc in Linus's tree.  I believe
> if you look you will find this feature was from a patch (perhaps from
> your distro) that added that support.

I compile both the util-linux-ng and the kernel from source.  There is no distribution patch involved.  As noted, kernel version 3.3.6 didn't bitch about the setting, while 3.4.0 does and won't mount procfs.

>From the man page (copy at "http://linux.die.net/man/8/mount"):

"Mount options for proc

     "uid=value and gid=value 

"These options are recognized, but have no effect as far as I can see."


Removal of this compatibility should have been noted.  WHERE was it noted?  Linux.die.net is a distribution independent documentation site.  It might not do anything, but per mount's documentation, it is acceptable.

