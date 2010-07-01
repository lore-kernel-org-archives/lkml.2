Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0GASGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:06:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56628 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0GASGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pfd+ZHIR4j3mnuQdeum8Cmx2hZxv0TQuDJPA42CRCbWMlmCjhfgWvKYvLgcGyIkbiW
         41SI5pWc4lrjDlQIz9thGV0NqGkqid639U7+NdxFnbi+XfA74vv2+6rhV9+fEtHW9tke
         pyLZjq/+gZRPEFcusivvhS/5HmWTLapPdtB3o=
MIME-Version: 1.0
In-Reply-To: <4C2CCE67.6070600@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	<1277923422.16256.8.camel@localhost>
	<4C2B9DAC.1030806@intel.com>
	<1277928125.18854.0.camel@localhost>
	<4C2BBACF.3080405@intel.com>
	<1277965264.18854.16.camel@localhost>
	<4C2C3B07.7050200@intel.com>
	<1277968336.4945.3.camel@localhost>
	<4C2C4319.6090906@intel.com>
	<1277972137.12558.2.camel@localhost>
	<4C2CCE67.6070600@intel.com>
Date: Thu, 1 Jul 2010 10:58:50 -0700
X-Google-Sender-Auth: 1a9Vf8OtEb-lUHupljE4-WLLdaA
Message-ID: <AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 10:20 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Chris, attached is a combined patch with David's catch for the VT-d
> misconfiguration, and some code to more gracefully handle this init failure
> in the driver.  Can you see if this resolves the problem? (remove the prior
> patches I have sent).

Thanks for the patch. I will test that and get back to you today.

Chris
