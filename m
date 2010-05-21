Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0EUHoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 03:44:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41529 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0EUHoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 03:44:04 -0400
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, greg@kroah.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, therbert@google.com,
       netdev@vger.kernel.org
References: <20100521162134.6b6326bd.sfr@canb.auug.org.au>
	<m1tyq1wy4h.fsf@fess.ebiederm.org>
	<20100520.235008.97331614.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 21 May 2010 00:43:55 -0700
In-Reply-To: <20100520.235008.97331614.davem@davemloft.net> (David Miller's message of "Thu\, 20 May 2010 23\:50\:08 -0700 \(PDT\)")
Message-ID: <m1pr0pwvgk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: davem@davemloft.net, netdev@vger.kernel.org, therbert@google.com, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, greg@kroah.com, sfr@canb.auug.org.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: manual merge of the driver-core tree with the net tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Thu, 20 May 2010 23:46:22 -0700
>
>> It looks right, except perhaps the RPS code looks like it will cause a
>> build failure with sysfs disabled, but that has nothing to do with your
>> changes.
>
> CONFIG_RPS depends upon CONFIG_SMP && CONFIG_SYSFS, so no that build
> failure is not possible.

That's the bit I'm missing.  My apologies if I caused any unnecessary worry.

Eric

