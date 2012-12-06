Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2LFX4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:56:34 -0500
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:29350 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753880Ab2LFX4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:56:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: l95w0csVM1kzILDzzXHga5m12W40WUI.z.8IbFgf0NcQQd1
 iQ0cXTuhvbr.dqjtQk_lE8VTNYj5SLRziDdC63H.yRsGyYmKco_0G0QzOJ97
 ni.Adc8C5kVhNkF2EgUsdBSLffcNygRv2Zms9E_8Xv4EO7MhJlBPk8L3GKaz
 z2O5BcDdOg7QwBBJkUwkM0J50_VnJEs4CldLXNs4h07s1FeSYVChab29EsPq
 s85P7DXIeZEBtEyYcPi3Zo2lHMn8Yp2z996HtFBY_v71.j0ypnjI8kZBL_JS
 PuGMReh3N1BJ6lfcuq7miwNHflbx4zKplLO0df2TL0z3MBglO5CoLIaMePdX
 hLnvSa5s0bXeF2XioLpPKFirEtYzpdrKDCt_ti_PLN6.E0IaFGruxZPBrUz4
 xLpqqlaO1v0v7nDngdyE56LpZkPhJ3eOh.Hp6hjpqujkLIuRDg8sg0.0fJTs
 EfgLAu0Ha35WQP0vmIazKkw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50C130B9.4030207@schaufler-ca.com>
Date: Thu, 06 Dec 2012 15:56:41 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: linux-next: unusual update of the security tree
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au> <50B5508D.7050409@schaufler-ca.com> <20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au> <alpine.LRH.2.02.1212070024460.4693@tundra.namei.org> <CA+55aFwJDtofV36R_ot8qj31BCGwBgDsGOKRkMRhRLamf5M+mw@mail.gmail.com> <alpine.LRH.2.02.1212071020050.7590@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1212071020050.7590@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/2012 3:21 PM, James Morris wrote:
> On Thu, 6 Dec 2012, Linus Torvalds wrote:
>
>> Have people pulled that thing into anything else? Because quite
>> frankly, I think it's unsalvageable except with a rebase.
> AFAIK, only developers such as Casey will have pulled it for development 
> purposes.
>
> And sorry, I should be checking the trees I pull from more carefully.

I have messed up and believe that I understand my error and the
impact that it has had on others. I also believe that I understand
what I should be doing henceforth. Once I get the word from James
I will rebase my tree from his. I will stop doing merges except as
recommended.

