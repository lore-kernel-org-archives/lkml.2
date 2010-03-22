Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0CVOlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:41:09 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:45940 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0CVOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bpS13xe451pibtr9yDECxFBwhwzSnT4s8iTHVVth4Tgwx4Fc4FExq0DcgKdhTIKEPT
         GkBwuPNKuzBrFC8SiqK/trCut/4ssY2z00Fcd4K0PLgBxJNHcd4vmkUU4dbxh1ir8MAi
         nVLd1LT0tlr5rKEOW5yekk0CdLp3kHP35gqsc=
MIME-Version: 1.0
In-Reply-To: <201003150942.49987.bjorn.helgaas@hp.com>
References: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com>
	 <1268601123.28444.21.camel@dc7800.home>
	 <463bccef1003141611q26229896y5d75b035552ff6fc@mail.gmail.com>
	 <201003150942.49987.bjorn.helgaas@hp.com>
Date: Mon, 22 Mar 2010 11:41:03 -0300
X-Google-Sender-Auth: 259ddabf8dcc05d2
Message-ID: <be7a9f3d1003220741g48f81ebbq963f97d3fc7673d7@mail.gmail.com>
Subject: Re: PCI conflicts with latest kernels
From: Otavio Salvador <otavio@ossystems.com.br>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Giampaolo Bellini <iw2lsi@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 15, 2010 at 12:42 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> [I re-added the CC: list, so the archives will have the whole
> conversation, in case anybody else has similar problems or
> can help answer this.]
>
> On Sunday 14 March 2010 05:11:55 pm Giampaolo Bellini wrote:
>> I apply the patch but seems that it does not solve conflicts
>
> Yes, I didn't expect it to fix anything, only to tell us more about
> what's happening.

Has any progress been done in this issue?

I have this same problem in VortexSX machine.

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
