Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2FEXJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:09:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38971 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2FEXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:09:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20120605082512.GC15171@moon>
	<20120605154743.53d494e6.akpm@linux-foundation.org>
Date: Tue, 05 Jun 2012 16:09:09 -0700
In-Reply-To: <20120605154743.53d494e6.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 5 Jun 2012 15:47:43 -0700")
Message-ID: <877gvl4aqy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19x2oKRRNOdkSlxWS+LjA2gms5BjWcokjU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fcntl: Add F_GETOWNER_UIDS option v3
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> um, OK.
>
> But we still have
>
> c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
> c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
> c-r-prctl-add-ability-to-get-clear_tid_address.patch
> c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch
>
> floating about unmerged due to various unresolved issues.  Can we
> please get all that stuff nailed down before working on new things?

Andrew I understand the frustration but in fairness this patch is just
as old as the patches you are talking about.   Cyrill just finished
resolving the unresolved isssues with this one,  aka a conflict with
user namespace support.

Now I do agree that we need to finish the rest of these things.

Eric
