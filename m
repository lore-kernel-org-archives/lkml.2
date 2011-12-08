Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1LHASd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:18:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34343 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1LHASb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:18:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Anca Emanuel <anca.emanuel@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com>
	<CAJL_dMtgP+BqFn3aGVBbGDJ+kMyGiEC_NmDURzh4mU=Jo=qZVA@mail.gmail.com>
	<CAPLs8y8vhioqc3CPrD7ugmVkR2DjKWNm8+T5j9QQnrxi=BgvdA@mail.gmail.com>
	<CAJL_dMtvgnZHH0uLE3j7Mg2Xqwt2rd90Uy0pUxm6muPmjFbkQg@mail.gmail.com>
	<CAJL_dMvbL0LBrJ4irP3vd_PA458i0YefWpmvMgphuT+TnF2O5Q@mail.gmail.com>
	<CAPLs8y-sc7CZw2Yb11A-jTEMmTYva==XHgCqK1UmWN6_HX0rfA@mail.gmail.com>
Date: Wed, 07 Dec 2011 16:19:53 -0800
In-Reply-To: <CAPLs8y-sc7CZw2Yb11A-jTEMmTYva==XHgCqK1UmWN6_HX0rfA@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Wed, 7 Dec 2011 03:44:29 +0200")
Message-ID: <m162hrgbiu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/KgUK6AYfC3tXHbiCJQ0p7V3gCTLiIqcw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: v6: faster tree-based sysctl implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Wed, Dec 7, 2011 at 2:08 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>> You can ask Stephen Rothwell to include your tree in next.
>> git://github.com/luciang/linux-2.6-new-sysctl.git  v6-new-sysctl-alg
>
>
> Thank you Anca, but I don't want to pollute Stephen's linux-next tree ATM.
> I'd wait until a maintainer chimes in and agrees that this approach is
> sound.

Which is my cue to say that I am behind the power curve in reviewing
this.  I will see if I can get to this before the end of the week.

Doing this and getting it right is definitely something we need to do.

We do need to be careful so that the code we wind up with is not just
faster but more maintainable than what we have today.

Thanks for still pushing this,

Eric

