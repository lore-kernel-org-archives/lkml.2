Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1IVRsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:48:39 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60607 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1IVRsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
Date: Thu, 22 Sep 2011 10:48:36 -0700
X-Google-Sender-Auth: mAiLNtK70ph6nYw8YwyJPi2yjtA
Message-ID: <CAA9_cmdrwf-xKa2cV1ZzSDiqkjEPdQQdQr9sY6Zn7kvUMbh9qw@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
From: Dan Williams <dan.j.williams@intel.com>
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>,
        James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 9:55 AM, Mark Salyzyn
<mark_salyzyn@us.xyratex.com> wrote:
> Except for the fact the patch as located in the attachment is still not in compliance, the patch works for me.
>
> Sincerely -- Mark Salyzyn
>
>> scsi-misc-2.6/scripts/checkpatch.pl 0001-SCSI-libsas-Allow-expander-T-T-attachments.patch
> WARNING: line over 80 characters
> #57: FILE: drivers/scsi/libsas/sas_expander.c:1245:
> +                               if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||
>
> WARNING: line over 80 characters
> #59: FILE: drivers/scsi/libsas/sas_expander.c:1247:
> +                                    child_ex->t2t_supp && parent_ex->t2t_supp)) {
>
> WARNING: line over 80 characters
> #62: FILE: drivers/scsi/libsas/sas_expander.c:1250:
> +                                       sas_print_parent_topology_bug(child, parent_phy, child_phy);
>
> total: 0 errors, 3 warnings, 82 lines checked
>

Minor infractions of 80 columns are acceptable when they improve readability.

checkpactch clean to me is no errors.

--
Dan
