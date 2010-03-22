Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0CVV1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:27:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:51453 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0CVV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ReNsuSCY74+NZu3QRCRG1F6xylAq9nhHugIJR9KuY63xmlLO+fRe1QCJSO1QdqWdsK
         rFBFSa9xJDUYi2NpBO3TESITjSipW84+mpdRW5rpB2jDqUS/vyotEe+PtVpEEVY+fKvs
         ygfmNsPsW81KfbD9PKZT0VhHHgKMpNrZ5ZGQQ=
MIME-Version: 1.0
In-Reply-To: <201003220850.39053.bjorn.helgaas@hp.com>
References: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com>
	 <201003150942.49987.bjorn.helgaas@hp.com>
	 <be7a9f3d1003220741g48f81ebbq963f97d3fc7673d7@mail.gmail.com>
	 <201003220850.39053.bjorn.helgaas@hp.com>
Date: Mon, 22 Mar 2010 18:27:18 -0300
X-Google-Sender-Auth: 173df252a2218f47
Message-ID: <be7a9f3d1003221427l484014faq188552d6fce59e9f@mail.gmail.com>
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

Hello Bjorn,

On Mon, Mar 22, 2010 at 11:50 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Monday 22 March 2010 08:41:03 am Otavio Salvador wrote:
>> I have this same problem in VortexSX machine.
> Can you post your entire dmesg log and a description of what
> problem you're seeing (e.g., device X doesn't work or whatever)?
> If this is a regression, i.e., your system used to work and
> now doesn't work, please tell us which version used to work
> and when it broke.

This has already been done at http://article.gmane.org/gmane.linux.kernel/916237

Cheers,

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
