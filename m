Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1BAUOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:14:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58010 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1BAUOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:14:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <1296578246.12605.22.camel@moss-pluto>
	<1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
	<m1r5brr1mn.fsf@fess.ebiederm.org>
	<AANLkTik+N5J-MDrbMbtwRPwz==J4y8sbBkhir=1K3g=B@mail.gmail.com>
Date: Tue, 01 Feb 2011 12:14:10 -0800
In-Reply-To: <AANLkTik+N5J-MDrbMbtwRPwz==J4y8sbBkhir=1K3g=B@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Tue, 1 Feb 2011 21:46:42 +0200")
Message-ID: <m1k4hjqzql.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VpzgyRn80DlVQj5hHKaYI290f8X/kRak=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] security/selinux: fix /proc/sys/ labeling
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Tue, Feb 1, 2011 at 9:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> What kernel has a dentry_path_raw?  Perhaps you mean __dentry_path?
>
>
> See the function here:
> https://github.com/mirrors/linux-2.6/blob/70d1f365568e0cdbc9f4ab92428e1830fdb09ab0/fs/dcache.c
>
> The last patches were against 2.6.38-rc2 because the dcache layer got
> rewritten in 2.6.38 http://lwn.net/Articles/421784/
>
> __dentry_path is now static (in fs/dcache.c) and does not take the
> necessary locks.

Thanks.  I thought I was looking at the latest source but it turns out
I fat fingered something and my tree was still 2.6.36-rc3.  Sigh.

dentry_path_raw does seem reasonable.

Eric
