Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0JYP2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:28:55 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:32534 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751483Ab0JYP2y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:28:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YHnmBR4yhXy23pURCNmtPYpf639+qThyu/DrVT+B4mFZCkJkHbZ4wfabHYJ6jJqmiIER7DYhqTJvxgQ58dwKDT9vopzmGcs3UTKwytgsn60ActbeVQXKwckAW6yBW9kvNP+xor/RTpo5vGvEEBccHJyHbGFiN51uDYZyMSwpBrs=;
Message-ID: <596336.88845.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: fHhGKGMVM1lhX5kN4m8aA1_e032R2cNWivwkwqkL4ZeiDFc
 ognxRduUAh_xVg2LDKDoohUSaM70vEiwkwromKinb6oxSMJoI1FmwoRD3.sj
 IjTC_daYMl7mOzkefkvgcWSw8TNRU2CPVwucEAHIl_v37aVnAyVsjR8tCNS0
 r5cc7Gk7Vp1P1x3SUw3JwWVvXmcQ8YIynFjLOzFWEZHPSffDhZDm3A8pGVkr
 nVWpHUrY7Wkx71q4sfSudxNt20T_ZYagJyYgrAeg7slOUkgBApAFglDBIqU3
 iAWQ2ZSQ__tSuc_ILNPju4ll_gt6ag0F4qIoiGY9ZMmDb04uvsTEnj5eNnW2
 dz.KAIICLSI1Ubq9ue.NttilZVBbD_FcfXuu9lh2duRFSRh0iXA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:28:53 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 12/29] memstick: mspro: rework interface switch
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-13-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 12/29] memstick: mspro: rework interface switch
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Now no old style state machine
> exist.
> Thus this patch removes now unused code.
> 

This patch does somewhat more, than just removing the dead code.
Description/rationale?



      
