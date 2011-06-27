Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1F0GFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:05:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1F0GCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=Kvkj5hsnRrG6Yoa0XKnwWtJyI7ECD8Y125QlZ4NQ8C2JZzLcvCQjE43jmYgrvTb9SW
         MyOtSFgbVhowp/ep7HQr8QaphnVWo/A/ukocnCZr3OLeNY0BK9ZuQEHABl9d4kFMm4Uy
         VMupMmA91C0vqdd5cHyuZ0GCwBMRdvYBnK/DQ=
Subject: Re: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mtd@lists.infradead.org, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jun 2011 09:03:26 +0300
In-Reply-To: <BANLkTikmCY8UjJWRKTkM_QW2_Bxw4yqPfQ@mail.gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
	 <1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
	 <1309153545.23597.13.camel@sauron>
	 <BANLkTikmCY8UjJWRKTkM_QW2_Bxw4yqPfQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309154611.23597.18.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 09:51 +0400, Dmitry Eremin-Solenikov wrote:
> On 6/27/11, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > On Mon, 2011-06-27 at 01:03 +0400, Dmitry Eremin-Solenikov wrote:
> >> ofpart.ko also provides ofoldpart MTD parser. Add respective
> >> MODULE_ALIAS("ofoldpart"); declaration.
> >>
> >
> > Why we need the alias?
> 
> Please check the parse_mtd_partitions code. If requested parser
> isn't registered, it tries to load corresponding module. So, this alias
> is necessary in the semi-bogus case when one will have the list
> of parsers containing ofoldpart, but not ofpart partition parser.

Fair enough, but would you please prepend MODULE_ALIAS with a comment
like this which explains why we need the alias?

-- 
Best Regards,
Artem Bityutskiy

