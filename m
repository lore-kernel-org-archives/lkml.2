Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2EBTlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:41:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41732 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2EBTlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:41:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, jasowang@redhat.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<20120502055008.GA29319@redhat.com>
	<20120502.024427.22049954455309204.davem@davemloft.net>
	<20120502081141.GA30549@redhat.com>
Date: Wed, 02 May 2012 12:40:55 -0700
In-Reply-To: <20120502081141.GA30549@redhat.com> (Michael S. Tsirkin's message
	of "Wed, 2 May 2012 11:11:43 +0300")
Message-ID: <87pqammkvs.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+SCeJaWcnZtdRoObylqp9l5dB1nnImuuw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Michael S. Tsirkin" <mst@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [V2 PATCH 0/9] vhost/macvtap zeropcopy fixes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Side question.  Are you aware that macvtap/vhost net is broken
in the presence of  vlan accelleration and that vlan accelleration
is not optional if you are using vlan headers?

Eric

