Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0EUGqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:46:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59957 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab0EUGq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:46:29 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tom Herbert <therbert@google.com>,
       David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <20100521162134.6b6326bd.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 20 May 2010 23:46:22 -0700
In-Reply-To: <20100521162134.6b6326bd.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Fri\, 21 May 2010 16\:21\:34 +1000")
Message-ID: <m1tyq1wy4h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, netdev@vger.kernel.org, davem@davemloft.net, therbert@google.com, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: manual merge of the driver-core tree with the net tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Greg,
>
> Today's linux-next merge of the driver-core tree got a conflict in
> net/core/net-sysfs.c between commits
> 0a9627f2649a02bea165cfd529d7bcb625c2fcad ("rps: Receive Packet Steering")
> and fec5e652e58fa6017b2c9e06466cb2a6538de5b4 ("rfs: Receive Flow
> Steering") from the net tree and commits
> bc28c84244da26bafb0d3bce95ef45212b31c6b8 ("net/sysfs: Fix the bitrot in
> network device kobject namespace support") and
> 83dc0fbf37495691219d019ec16b40d8592d2956 ("net: Expose all network
> devices in a namespaces in sysfs") from the driver-core tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary.

It looks right, except perhaps the RPS code looks like it will cause a
build failure with sysfs disabled, but that has nothing to do with your
changes.  I don't see any real conflicts here, just two patches passing
very close to each other.

Thanks for the heads up.

Eric
