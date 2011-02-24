Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1BXG4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:56:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48536 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab1BXG4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:56:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        David Howells <dhowells@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
References: <20110223135814.GA1859@mail.hallyn.com>
	<20110217150224.GA26334@mail.hallyn.com> <29677.1298462729@redhat.com>
	<890.1298473574@redhat.com> <m162sasqj6.fsf@fess.ebiederm.org>
	<20110223155328.GA21266@peq.hallyn.com>
	<4D655EE4.6030707@schaufler-ca.com> <m1k4gqlbdm.fsf@fess.ebiederm.org>
	<4D657E0C.3010102@schaufler-ca.com>
Date: Wed, 23 Feb 2011 22:56:01 -0800
In-Reply-To: <4D657E0C.3010102@schaufler-ca.com> (Casey Schaufler's message of
	"Wed, 23 Feb 2011 13:37:16 -0800")
Message-ID: <m1vd09gbum.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+I8mnDoyaCsb3jHXuUdmcs2N3y6TAznt0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
Subject: Re: User namespaces and keys
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> On 2/23/2011 12:55 PM, Eric W. Biederman wrote:
>> Casey Schaufler <casey@schaufler-ca.com> writes:
>>
>>> I confess that I remain less well educated on namespaces than
>>> I probably should be, but with what I do know it seems that the
>>> relationships between user namespaces and LSMs are bound to be
>>> strained from the beginning. Some LSMs (SELinux and Smack) are
>>> providing similar sandbox capabilities to what you get from user
>>> namespaces, but from different directions and with different
>>> use cases.
>> Casey I won't argue about the possibility of things being strained, but
>> I think if we focus on the semantics and not on the end goal of exactly
>> how the pieces are to be used there can be some reasonable dialog.
>
> I'm sure that there will be cases where they will work together
> like horses in a troika. Making sensible semantics for the interactions
> is key, and it is entirely possible that in some cases a comparison
> of semantics and behaviors will lead an end user to chose either an
> LSM or namespaces over the combination. Just like I expect that even
> when we allow multiple LSMs the SELinux and Smack combination will be
> rare among the sane.

That sounds about right.

Eric

