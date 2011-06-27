Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1F0Fxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:53:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58749 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab1F0FvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C1O4utAyzTCvKj1avKpgBqKGK8fN/9DDM9GibmZhQfi+G0LKih30Pfh+7U+S9OMnLW
         wOtYm1HB5+KEhbkr/SHa4bXTQbtYGQkk8/Pnuenvt5xpVtsi3E1xhEwVh6cW94zF8IpJ
         UogDoglS8PBXCa8DQ4WkZmhBxW7mhEnBJW/80=
MIME-Version: 1.0
In-Reply-To: <1309153545.23597.13.camel@sauron>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
	<1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
	<1309153545.23597.13.camel@sauron>
Date: Mon, 27 Jun 2011 09:51:24 +0400
Message-ID: <BANLkTikmCY8UjJWRKTkM_QW2_Bxw4yqPfQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/11, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Mon, 2011-06-27 at 01:03 +0400, Dmitry Eremin-Solenikov wrote:
>> ofpart.ko also provides ofoldpart MTD parser. Add respective
>> MODULE_ALIAS("ofoldpart"); declaration.
>>
>
> Why we need the alias?

Please check the parse_mtd_partitions code. If requested parser
isn't registered, it tries to load corresponding module. So, this alias
is necessary in the semi-bogus case when one will have the list
of parsers containing ofoldpart, but not ofpart partition parser.

-- 
With best wishes
Dmitry
