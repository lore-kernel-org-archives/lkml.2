Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1CNUaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:30:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54942 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1CNUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g9t+jmDajL1cob51IliDNa83d0VmGblSDGqBdEwIzz16RTf1Rq8VAhzqxppnsfGHcx
         B7B3AEny/3Esl3JV85WtIn7ZFrtJlCNIekWWeP6rcJW9jTNsP9dPshZaFzMBa0pzMzAB
         NPFlaLtqA29JHEgEcZ0wcZsR/thugXdBu738E=
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
In-Reply-To: <20110314131042.5a7fb32f.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	 <201103111255.44979.arnd@arndb.de>
	 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	 <20110311235607.GB15853@elie>
	 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	 <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com>
	 <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
	 <20110314131042.5a7fb32f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 22:29:55 +0200
Message-ID: <1300134595.2332.17.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 13:10 -0700, Andrew Morton wrote:
> There might one day be a requirement to be able to initiate a
> resource-management-style writeback against a whole filesystem.  When
> that happens, we'll regret not having added a "mode" argument to
> sys_syncfs().

I think Indan is right about an additional argument which could be used
for future extensions, what is the problem adding it?

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

