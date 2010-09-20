Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0ITJW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:22:26 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:40762 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755812Ab0ITJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:22:24 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: kUTXXFcVM1nYsRnSvNklI6HtQrHPx_8gj_YF_pLG6t8NCvy
 _O3F_WHOkPQKHToRqjyaf20hQ73Edu_z2u7FagOSTudPyYnRuL8k5.Z0694I
 wYiixKCcxOOQapHsR6c4KX0G.KtN09pY3vupTvTfpBJaHm.gmI5OCg2TpUo8
 wfrmJkurJKEq2Bc6bNCGhU5vai7YL3b5C8Q7qlMydKn9jdVvWCYzAwvrZF.q
 6WvDhmwSdkyNksGe5EzB4agpwDs91MeiHopeDVypmUK1KSzRhRCKiHXMf3JE
 2KvTjuKjwpdCdj1bf1Mf7pyeSmS_zAZJt4ONc6VHgEcM08AU3iwDZQwAc
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de, michaelc@cs.wisc.edu, konrad@darnok.org,
        jeykholt@cisco.com, hare@suse.de, hch@lst.de, James.Smart@Emulex.Com,
        andrew.vasquez@qlogic.com, philipp.reisner@linbit.com,
        martin.petersen@oracle.com, vasu.dev@linux.intel.com,
        Joel Becker <joel.becker@oracle.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4C961644.70209@panasas.com>
References: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>
	 <20100918125729D.fujita.tomonori@lab.ntt.co.jp>
	 <1284841932.13344.339.camel@haakon2.linux-iscsi.org>
	 <4C961644.70209@panasas.com>
Content-Type: text/plain
Date: Mon, 20 Sep 2010 02:18:10 -0700
Message-Id: <1284974290.13344.466.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 15:55 +0200, Boaz Harrosh wrote:
> On 09/18/2010 10:32 PM, Nicholas A. Bellinger wrote:
> > On Sat, 2010-09-18 at 13:00 +0900, FUJITA Tomonori wrote:
> > So the RFC cuts have been going into a seperate tree here:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=summary
> > 
> 
> This is the two weeks ago stuff, right. Where is the lio-core-2.6.git/ ?
> 
> > Mike has requested an RFC v2 for him to review TCM Core and TCM_Loop
> > v4.0.0-rc4 changes.  So I will be respinning this tree with the latest
> > changes from lio-core-2.6.git/lio-4.0 and re-posting in the next days.
> > 
> 
> Me to. And a git tree and a git web, as well. I'll postpone any review
> to that time.

Hi Boaz,

So as mentioned earlier, the main upstream branch where all of the
review changes have been moving through is located at
lio-core-2.6.git/lio-4.0:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/lio-4.0

I will be doing a RFCv2 posting for TCM Core and TCM_Loop v4.0.0-rc4
with the very latest changes this week for Mike, Tomo-san and yourself
to further review.  This series will be in the usual one-file-per-commit
format and will be pushed these into a rfcv2-for-37 branch against
v2.6.36-rc4 in the seperate pristine lio-4.0.git tree mentioned above.

Also just FYI, the workflow I plan to use post-merge for TCM is to
continue to merge all changes in via the lio-core-2.6.git tree, and send
out pull requests for patches destined to mainline via a seperate
pristine tree + branches.

Best,

--nab


