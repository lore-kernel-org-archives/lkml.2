Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1BWVhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:37:19 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:35106 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756029Ab1BWVhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:37:17 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 7Ws2l_AVM1nbZxQxgf9LtULYrL27K6_RGyU7w3qWIie82ju
 0mgfNP8FDrOISVM1MWz1aOZtEdMMW2mfc6s9qnidcTRMzfWspgeo03vNSNlt
 EuWqfnYPzCWUwVwJh5VLGxa_oaIfSmQ5b2M_Lu3eOPYctaXeDnBsNzMS6q_l
 kzoQhTcZ5PDyDNAT2POUjkH4V6lnTn.Ar1EJfUF_r4O94Es.Lo7PUH_WavMO
 aZ.OMELSMWkDYK76WrvIEhzs12CkGn0ZohNZKbXWBB276q7MFGmWMqOlHLVe
 G1BOoe1TsMyoVhMDeD7rSJQqzxYg-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D657E0C.3010102@schaufler-ca.com>
Date: Wed, 23 Feb 2011 13:37:16 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        David Howells <dhowells@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: User namespaces and keys
References: <20110223135814.GA1859@mail.hallyn.com>	<20110217150224.GA26334@mail.hallyn.com> <29677.1298462729@redhat.com>	<890.1298473574@redhat.com> <m162sasqj6.fsf@fess.ebiederm.org>	<20110223155328.GA21266@peq.hallyn.com>	<4D655EE4.6030707@schaufler-ca.com> <m1k4gqlbdm.fsf@fess.ebiederm.org>
In-Reply-To: <m1k4gqlbdm.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/2011 12:55 PM, Eric W. Biederman wrote:
> Casey Schaufler <casey@schaufler-ca.com> writes:
>
>> I confess that I remain less well educated on namespaces than
>> I probably should be, but with what I do know it seems that the
>> relationships between user namespaces and LSMs are bound to be
>> strained from the beginning. Some LSMs (SELinux and Smack) are
>> providing similar sandbox capabilities to what you get from user
>> namespaces, but from different directions and with different
>> use cases.
> Casey I won't argue about the possibility of things being strained, but
> I think if we focus on the semantics and not on the end goal of exactly
> how the pieces are to be used there can be some reasonable dialog.

I'm sure that there will be cases where they will work together
like horses in a troika. Making sensible semantics for the interactions
is key, and it is entirely possible that in some cases a comparison
of semantics and behaviors will lead an end user to chose either an
LSM or namespaces over the combination. Just like I expect that even
when we allow multiple LSMs the SELinux and Smack combination will be
rare among the sane.

