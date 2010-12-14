Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0LNSnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:43:15 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47481 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0LNSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=OEWfbg59d1UDgviuupsNPLMPkRMvNx3uapYxxxP1IjtlDBQkxdr7gkayn2APh4IagV
         r6HgcmBVsXO5xzydraaRoznhi8oYOSgOjUxSmonNO8bTB4Ldz0fTdl5s0tALLSuDre13
         F3wDBkpCWlj8fWbW3y+2hMDKlH+4aecOEU42I=
Date: Tue, 14 Dec 2010 21:42:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: tfransosi@gmail.com, kernel-janitors@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] kernel/panic.c: Fix two checkpatch.pl errors
 (whitespace cleanup)
Message-ID: <20101214184253.GB1639@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	tfransosi@gmail.com, kernel-janitors@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1292345888-19129-1-git-send-email-toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292345888-19129-1-git-send-email-toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 05:58:08PM +0100, Toralf Förster wrote:
> nothing else
> 

This patch is not helpful.  I mean that in the sense that the code is
just as readable before and after.  :/  Please only send patches that
make the code better.

Checkpatch.pl is a good tool for staging but outside of staging you
should only use it for [check]ing [patch]es.  The problem is that
pointless churn clutters up the log and breaks git blame.  In staging
that's Ok.

regards,
dan carpenter
