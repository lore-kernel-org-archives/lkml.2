Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2EPOtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:49:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44647 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2EPOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:49:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120516193712.32157bcdc435465c27183baf@canb.auug.org.au>
	(Stephen Rothwell's message of "Wed, 16 May 2012 19:37:12 +1000")
References: <20120516193712.32157bcdc435465c27183baf@canb.auug.org.au>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Wed, 16 May 2012 07:49:16 -0700
Message-ID: <87ehqk5ggj.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Gxj8SMTbBASWgQfLXI4zOZjGQvGop97k=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the akpm tree with the userns tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Andrew,
>
> Today's linux-next merge of the akpm tree got a conflict in
> kernel/signal.c between commit 54ba47edac90 ("userns: signal remove
> unnecessary map_cred_ns") from the userns tree and commit "pidns: use
> task_active_pid_ns in do_notify_parent" from the akpm tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks.

Eric

