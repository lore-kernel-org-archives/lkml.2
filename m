Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2EXOSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:18:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36041 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2EXOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:18:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
Cc: linux-kernel@vger.kernel.org
References: <jpk8nr$2f8$1@snarked.org>
Date: Thu, 24 May 2012 08:17:56 -0600
In-Reply-To: <jpk8nr$2f8$1@snarked.org> (D. Stussy's message of "Wed, 23 May
	2012 20:08:42 -0700")
Message-ID: <87wr411x4b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19L9sKZ5ne/662KcyChhYSzhfSw39U3yLw=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
X-Spam-Relay-Country: 
Subject: Re: Mounting /proc w/ kernel 3.4.0 - "uid" parameter no longer valid?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"D. Stussy" <spam+newsgroups@bde-arc.ampr.org> writes:

> proc:  unrecognized mount option "uid=1" or missing value
>
> This works under 3.3.6 and earlier (I never tried 3.3.7).  It appears that the
> "uid" mount option was removed.  WHY?  More importantly, where is this change
> listed?  I didn't see it in the git log.
>
> This is really bad as I rebooted a remotely colocated server and since the
> procfs is not mounted, I cannot log in via SSH to correct the problem.
>
> OK, so there's not that much point in changing the UID of the procfs files, but
> I preferred to set their default ownership to a non-privileged user. 

There has never been a uid= option to /proc in Linus's tree.  I believe
if you look you will find this feature was from a patch (perhaps from
your distro) that added that support.

Eric
