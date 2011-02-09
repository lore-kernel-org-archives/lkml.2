Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1BINP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 08:15:28 -0500
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:43869 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754755Ab1BINPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 08:15:24 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: wUz2oZkVM1mXmrF_EsJY9xfOB_AnyTV5wC1aaGm6viI4so3
 UX0NqJyhgv7Kc6TMcxk07o2i18dud7ATn9geTvJr0Ac1gu3Q7cT9gy0gWWD.
 vfR0CykYOJum2U09PKYRiLeKP4im5quI4ls45DJgBY6AoIZEl3I1e7BAdIa1
 v56FxGd44S7Vve5uzip2aNtgHKWrr2tUm9Dbx7PXdWVmdYEHe3Q4oJ.7HiZC
 XaqIApvw1pohmqmT6tZBo_o0JClRJ8sN.pD2yInzV.yZsEvV1EGXTKWJ1S_x
 WgjDm9NkSTsj01bT1BYZ9LSUD2PFmLZH2EenVH6L0
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D52936A.6010407@schaufler-ca.com>
Date: Wed, 09 Feb 2011 05:15:22 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 \(EXT-Tieto/Tampere\)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena \(Nokia-D/Helsinki\)" <elena.reshetova@nokia.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Subject: [PATCH] Smack: mmap controls for library containment
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com> <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/2011 11:51 PM, James Morris wrote:
> On Tue, 8 Feb 2011, Casey Schaufler wrote:
>
> Subject: [PATCH] Smack: correct behavior in the mmap hook
>
>   The mmap policy enforcement was not properly handling the
>   interaction between the global and local rule lists.
>   Instead of going through one and then the other, which
>   missed the important case where a rule specified that
>   there should be no access, combine the access limitations
>   where there is a rule in each list.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>

James, I made an error and failed to say that this and Shan Wei's clean-up
should be pulled from git://gitorious.org/smack-next/kernel.git


