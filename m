Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0HPIqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:46:33 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64560 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0HPIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=l2Omr0kkRmte5S3hhxqocDERzTkNlgxXhuf1DHGDw/cAOJPnCQX0pzKJZFLFmToBVA
         XxrMQTsATzL80e60QAuKHzRxvLLhDV4Fv0+bYYPeRsNWq/ozY27xUQMLD8MWZkgvpo6i
         w42r3eNpK6kEtblnNOivUz0Echs9drV+tUp9w=
MIME-Version: 1.0
In-Reply-To: <20100814090145.GW645@bicker>
References: <20100814090145.GW645@bicker>
Date: Mon, 16 Aug 2010 01:46:30 -0700
X-Google-Sender-Auth: jKCi_pvYozBBX8CSitZSDtXvn8k
Message-ID: <AANLkTikU6zTFhn7cTgTXD_DirG_i8=aqn6W8p-dd3F9_@mail.gmail.com>
Subject: Re: [patch] dma/shdma: move dereference below the NULL check
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Carpenter <error27@gmail.com>, Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 2:01 AM, Dan Carpenter <error27@gmail.com> wrote:
> "param" can be NULL here, so only dereference it after the check.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks, applied as obviously correct.

--
Dan
