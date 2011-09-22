Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1IVRly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:41:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46129 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1IVRlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
Date: Thu, 22 Sep 2011 10:41:50 -0700
X-Google-Sender-Auth: ZUQd_MxWVd_hnmiOX-9R6ntNVCg
Message-ID: <CAA9_cmfy0yttyAXZmY=MubRKOqT+uOescR=+J=y5jc_KfPbA8Q@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
From: Dan Williams <dan.j.williams@intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 9:41 AM, Luben Tuikov <ltuikov@yahoo.com> wrote:
> Allow expander table-to-table attachments for
> expanders that support it.
>
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>

...and can we tag this for -stable.  It meets the 100 line count and
"New device IDs and quirks are also accepted." constraints.
