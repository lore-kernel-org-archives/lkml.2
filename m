Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0HZFnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 01:43:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33169 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0HZFnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 01:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fepH6TGplLPmJeGnYSAzAFlIKMmH3YDw/kMofUpHjRv+ScQlR6i7cl5ijw5czXzP+a
         q1d7TvtL52i5nHpQTZ+4opdYTVA+NbGCkstGb920BMTHB2/czr81PXhhMXY72zii9eKD
         qBuXE4+0n9v3Hadowxze/3myOcmpp/11oAjV0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1008251656090.3037@localhost.localdomain>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
	<1282120734-11635-1-git-send-email-ike.pan@canonical.com>
	<alpine.LFD.2.00.1008251656090.3037@localhost.localdomain>
Date: Thu, 26 Aug 2010 07:43:10 +0200
Message-ID: <AANLkTi=STq=_K2NPnK4GM+XwruaR09m6QJ7nkuCJVQvB@mail.gmail.com>
Subject: Re: [PATCH 8/8] ideapad: Change the driver name to ideapad_laptop
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Ike Panhc <ike.pan@canonical.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 10:56 PM, Len Brown <lenb@kernel.org> wrote:
>>  drivers/platform/x86/ideapad_acpi.c   |  381 ---------------------------------
>>  drivers/platform/x86/ideapad_laptop.c |  381 +++++++++++++++++++++++++++++++++
>
> Acked-by: Len Brown <len.brown@intel.com>
>
> thanks,
> Len Brown, Intel Open Source Technology Center
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Probably not very important .. but .. other drivers are called *-laptop.c, not
*_laptop.c ..

asus-laptop.c classmate-laptop.c compal-laptop.c dell-laptop.c eeepc-laptop.c
fujitsu-laptop.c msi-laptop.c panasonic-laptop.c sony-laptop.c topstar-laptop.c

-- 
Corentin Chary
http://xf.iksaif.net
