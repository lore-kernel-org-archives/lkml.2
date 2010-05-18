Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0ERV7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:59:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45443 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0ERV7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:59:18 -0400
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
	<m1hbm5f0d2.fsf@fess.ebiederm.org> <20100518212502.GB31331@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 18 May 2010 14:59:09 -0700
In-Reply-To: <20100518212502.GB31331@kroah.com> (Greg KH's message of "Tue\, 18 May 2010 14\:25\:02 -0700")
Message-ID: <m1zkzwdg7m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: greg@kroah.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: build failure after merge of the driver-core tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Tue, May 18, 2010 at 12:58:33PM -0700, Eric W. Biederman wrote:
>> 
>> Greg this fixes the conflict with the vfs tree we see in linux-next.
>
> Thanks, I can apply this to my tree right now, right?

Yes it is safe to apply to your tree right now.  Apologies if that
wasn't clear.

Eric
