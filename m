Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1FOX0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 19:26:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1FOX0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 19:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PwiZaB4PFQ64BSJfdi366RlVviEGNfs+NyOJBa4eAv1TEIMvS9eyCAywxig3CHdc5t
         SHLsWGNvYD0Z/Ky5HDjA==
MIME-Version: 1.0
In-Reply-To: <20110606135221.GG12242@legolas.emea.dhcp.ti.com>
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
	<20110606135221.GG12242@legolas.emea.dhcp.ti.com>
Date: Wed, 15 Jun 2011 16:25:48 -0700
X-Google-Sender-Auth: AzIDtn37z31OWhB-9ABO87XRBSA
Message-ID: <BANLkTingZ1A=7YxZ4E4aZ40QETs5MHQnfSYOj9x6sUG2657M9w@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver initialization
From: Dima Zavin <dima@android.com>
To: balbi@ti.com
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is this not just a straight revert of
7e6502d577106fb5b202bbaac64c5f1b065e6daa?

On Mon, Jun 6, 2011 at 6:52 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> Oops are produced during initialization of ehci and ohci
>> drivers. This is because the run time pm apis are used by
>> the driver but the corresponding hwmod structures and
>> initialization is not merged. hence revering  back the
>> commit id 7e6502d577106fb5b202bbaac64c5f1b065e6daa
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>
> Reported-by: Luciano Coelho <coelho@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
>
> --
> balbi
>
