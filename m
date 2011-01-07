Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1AGBFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:05:23 -0500
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:31921 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755184Ab1AGBFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:05:22 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: Bxv52r4VM1kdsmaQKRXgOaiZyzzmBJfTRbS6.BuKKh9A5f4
 k5yndJ7xHUJ8.XlF3ymWWFwdednN0AGjoITVOS_EBUePBMKu7W9x7c7Or5Ys
 GM8tyy_Pz8sx2pAZBDkG62_Im3YNB.8xHOmRZm7zjHdQxiXnrfzaYaB3QBG5
 Dqxg_MljuyEdczkSffZXLi75ff4HQBZjWi2UwYPPX0xv23kmbh_j6IXds4TS
 QCWfRHxQmWcdUrx6YDcjtnspADbWqafebBjBe5ueAb5KH0ZDeZY_4_WBVNJm
 s55MkqvoNgRx3mxwmPtMgawUHr8vhHqB3rfQ-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D2666D0.9060802@schaufler-ca.com>
Date: Thu, 06 Jan 2011 17:05:20 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: linux-next: manual merge of the security-testing tree with the
 net tree
References: <20110107114400.e4d1d33b.sfr@canb.auug.org.au>
In-Reply-To: <20110107114400.e4d1d33b.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2011 4:44 PM, Stephen Rothwell wrote:
> Hi James,
>
> Today's linux-next merge of the security-testing tree got a conflict in
> security/smack/smack_lsm.c between commit
> 3610cda53f247e176bcbb7a7cca64bc53b12acdb ("af_unix: Avoid socket->sk NULL
> OOPS in stream connect security hooks") from the net tree and commit
> b4e0d5f0791bd6dd12a1c1edea0340969c7c1f90 ("Smack: UDS revision") from the
> security-testing tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary.

The change looks like it addresses the change in interface. Thank you.

