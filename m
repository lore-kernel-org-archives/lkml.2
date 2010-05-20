Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0ETEOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 00:14:14 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:42730 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0ETEOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 00:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gPT8qk/d/ems+RDEWRsxsA7EQ8HIqKM6odbv0hH3wYCFDC5q2ZyMt++RsXqWxPeGYn
         y5vsKX/ihBtrsugDKPSu354XzLF4DOIRD34JFo4MyCMy1NYZRiDCNAHbUt/JGDqWeXHU
         rxgQEbt2gCVmKFHTIgr4ivY5wyuK830O0Jugg=
Subject: Re: [GIT PULL 0/2] perf session fix host_machine handling wrt
 build ids
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <1274288493-15523-1-git-send-email-acme@infradead.org>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
Content-Type: text/plain
Date: Wed, 19 May 2010 23:14:08 -0500
Message-Id: <1274328848.8913.2.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 14:01 -0300, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Stephane and Tom,
> 
> 	Now the build id code should be back working:

Thanks for providing the fix!

Tom

