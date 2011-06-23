Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab1FWOwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:52:10 -0400
Received: from mail.bbaw.de ([194.95.188.6]:40655 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1FWOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:52:09 -0400
Date: Thu, 23 Jun 2011 16:52:06 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: extra slash in current path
Message-Id: <20110623165206.d88dcbb3.taeuber@bbaw.de>
In-Reply-To: <4E034E2A.1010100@msgid.tls.msk.ru>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
	<20110623153116.404f2a63.taeuber@bbaw.de>
	<BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
	<BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com>
	<BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
	<4E034E2A.1010100@msgid.tls.msk.ru>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.24; VDF: 7.11.10.79; host: mailhub); id=24157-poq3kE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 23 Jun 2011 18:31:06 +0400
Michael Tokarev <mjt@tls.msk.ru> schrieb:
> 23.06.2011 18:11, yuyichao-mit wrote:
> 
> >>>> $ cd //
> >>>> $ pwd
> >>>> //
> 
> The current directory is cached in $PWD environment
> variable by shell (bash at least).  This variable is
> checked in glibc (getcwd() et al) - if it is set and
> stat($PWD) is the same as stat("."), that value is used.

It also is somehow cached inside bash/dash for it's built in commands.
$ cd //
$ export PWD=5
$ pwd
//
$ /bin/pwd
/


Regards
Lars
