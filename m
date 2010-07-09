Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0GIKIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:08:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40008 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0GIKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:08:20 -0400
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20100709150117.51612026.sfr@canb.auug.org.au>
	<4C36EF9C.7010804@in.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 09 Jul 2010 03:08:02 -0700
In-Reply-To: <4C36EF9C.7010804@in.ibm.com> (Sachin Sant's message of "Fri\, 09 Jul 2010 15\:15\:00 +0530")
Message-ID: <m1d3ux55od.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; sa06 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sachin Sant <sachinp@in.ibm.com>
X-Spam-Relay-Country: _RELAYCOUNTRY_
Subject: Re: [-next July 9 - s390 ] Badness at fs/sysfs/symlink.c:82 during qeth initalization
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant <sachinp@in.ibm.com> writes:

> With today's next(20100709) qeth interface fails to initialize
> with following Badness message:

> sysfs: symlink across ns_types 0.0.6000/net:eth0 -> net/eth0

Is this with CONFIG_SYSFS_DEPRECATED set?

I think I may have made my warning check a little extra strict.

Eric
