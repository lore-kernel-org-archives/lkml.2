Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0JVQN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:13:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55855 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0JVQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QtkpWQ7MwVUKVb2fzlqi1g50Rbna2pSyVLk9bYOvBnj/v2Ok2oYi/n0nvY9Tub1Pv5
         /HtWwmQlpZpCumAGwR04GjapX+j5fDAQ0Ubj3pNcPw0SEowbmi329nnSE4pEnYzT73Qv
         dSy5Y0hluidxnY0oUbjWH9hNeMe+Sabl+X2fE=
Subject: Re: [PATCH] block2mtd: dubious assignment
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Nicolas Kaiser <nikai@nikai.net>, Joern Engel <joern@lazybastard.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101022143416.GA12737@logfs.org>
References: <20101022124724.59eba464@absol.kitzblitz>
	 <20101022143416.GA12737@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 19:13:50 +0300
Message-ID: <1287764030.7480.1.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 16:34 +0200, Jörn Engel wrote:
> On Fri, 22 October 2010 12:47:24 +0200, Nicolas Kaiser wrote:
> > 
> > When block2mtd_erase fails, a duplicated assignment instantly
> > changes instr->state from MTD_ERASE_FAILED to MTD_ERASE_DONE.
> > 
> > It looks to me like this might not be intended, or is it?
> 
> Definitely not.  Just proves how well block device errors are tested.
> 
> > Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> Acked-By: Joern Engel <joern@logfs.org>
> 
> Artem, can I leave this patch to you as well?

Yes, I'll put it to my l2 tree of course, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

