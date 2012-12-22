Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2LVCm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:42:58 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43893 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2LVCmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:42:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<1355814959-10573-25-git-send-email-yinghai@kernel.org>
	<20121222023741.GF3468@phenom.dumpdata.com>
Date: Fri, 21 Dec 2012 18:42:47 -0800
In-Reply-To: <20121222023741.GF3468@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Fri, 21 Dec 2012 21:37:41 -0500")
Message-ID: <87bodmhkns.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18m/2mrTqCnMrlEOPStt99ti99aLqVJSFI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7 24/27] x86: Add swiotlb force off support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Mon, Dec 17, 2012 at 11:15:56PM -0800, Yinghai Lu wrote:
>> So use could disable swiotlb from command line, even swiotlb support
>> is compiled in.  Just like we have intel_iommu=on and intel_iommu=off.
>
> You really need to spell out why this is useful.

YH why can't we safely autodetect that the swiotlb is unusable when
there is no memory below 4G free?

Eric
