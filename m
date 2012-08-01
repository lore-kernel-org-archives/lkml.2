Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2HAOVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:21:03 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65152 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab2HAOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120729215301.GA27358@srcf.ucam.org>
References: <1343407934-459-1-git-send-email-mjg@redhat.com>
 <1343407934-459-3-git-send-email-mjg@redhat.com> <1343598582.15288.4.camel@shinybook.infradead.org>
 <20120729215301.GA27358@srcf.ucam.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 1 Aug 2012 08:20:15 -0600
Message-ID: <CAErSpo7KKgrtL1ti5dYnykTMiKU2Gf-pviMFqBombdqGih98JA@mail.gmail.com>
Subject: Re: [PATCH] Fix priority of non-BAR ROM data
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Woodhouse <dwmw2@infradead.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 3:53 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Jul 29, 2012 at 10:49:42PM +0100, David Woodhouse wrote:
>> +      * Some devices may provide ROMs via a source other than the BAR
>> +      */
>> +     if (pdev->rom && pdev->romlen) {
>> +             *size = pdev->romlen;
>> +             return phys_to_virt(pdev->rom);
>
> Needs casting. My mistake.

Matthew, are you going to fold this into your patch and repost your
series, or is this a logically separate issue?
