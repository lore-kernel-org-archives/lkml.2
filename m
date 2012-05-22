Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2EVOlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:41:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50470 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2EVOla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:41:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, viro@zeniv.linux.org.uk, tixxdz@opendz.org
References: <1337647392.13348.14.camel@gandalf.stny.rr.com>
Date: Tue, 22 May 2012 08:41:17 -0600
In-Reply-To: <1337647392.13348.14.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Mon, 21 May 2012 20:43:12 -0400")
Message-ID: <878vgk1do2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+pNZ6QDF1OptdR1sdPUAfcpU9cNpwP0zA=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] net: Surpress kmemleak messages on sysctl paths
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> The network code allocates ctl_table_headers that are used for the life
> of the kernel. These headers are registered and never unregistered. The
> head pointer is allocated and not referenced, as it never needs to be
> unregistered, and the kmemleak detector triggers these as false
> positives:

The fix for this should already be merged into Linus's tree from the
net-next tree for 3.5.

Eric
