Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab2K0XpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:45:13 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:45722 "HELO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751951Ab2K0XpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:45:11 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jI.9ObkVM1ntRMAQ3l6ST2XPGivF6KXTVlWWZqErXwZLx_7
 08p0CPxnnsKvPeH5LtdimCBroClaI.lPhEFBj6cwqeEflQWcbqp.rjmSOt5t
 geU18oQLS1HjdTcrG5Ps01OJFt7I.1F215W9sPU.BjVNyFGd1oBIO2dwcgri
 UOo2wysBiSKj_S15V9N6MvG71rcvyexBTgeED1EGF7DZInixBrWrK_nQEPaR
 l4GYbWXFvKkw0uPxuZvf.CHQssjymiyYro5YxENRMI6mFJ327Wye7BzKp6vb
 sB9OvBC_mT5nTzdjQ0DowHbpBheILfu1ZzQ5XHiYU80P_GyNbwGwurTnY2ym
 DY9PsN_vFtDKAoHqNfgAQTdBVe0KYoxNneZDGLFLZJ2Fm1eR3AtsCM.hFxHR
 XSc2bS8tfZk0I7GJrWDc.vjlWmrGAEUiFQz43dehIz8JgNzt55utFnijQUur
 L6czcOFRX7hCIWi0ieBpBs5KzSh5H_pJx_WGJhtURWKCuAaTwOjp5jqx9LIU
 wHOWoYH2Z20XGr2W1J..O_IrcWstjVkwxQufCOMv.ybdGmrNajGc79FtlZRm
 V_cAdCL_xi.T72UZEJhd8
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B5508D.7050409@schaufler-ca.com>
Date: Tue, 27 Nov 2012 15:45:17 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: linux-next: unusual update of the security tree
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
In-Reply-To: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 3:16 PM, Stephen Rothwell wrote:

> Hi James,
>
> The security tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git#next)
> looks a bit strange today ... It appears to have been created by Casey
> Schaufler (cc'd) and contains some quite old commits and back merges of
> your tree.  I *guess* you have merged in Casey's tree after he merged in
> your tree from yesterday.

I *thought* that I had used the same procedures that worked before.
In fact, I still do think that, but if it's a problem I can purge my
smack-next tree and start over.

James, the two changes that came from smack-next are pretty minor. I
don't think you should hesitate to back them out if that helps.


>
> Just for your consideration.
>

