Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1FIJN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:13:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48275 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1FIJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bh1SeUmFQKjXTb0UkMmWOtvABdjR5hNd4BUS+oC8FVYXxTiGraBcUPAcRX6NXGIxlI
         iMEkw0ayTDvHq8l8lkZtXn7w5QB1CBQsPZZ69/KVR5MeTtaXQT4gQaPsfjenov+kdjgz
         kPAhoeAHqN4G7F/XmHeXulk3/BixsYWxeERAY=
MIME-Version: 1.0
In-Reply-To: <20110609091705.GA2190@mail.fossee.in>
References: <20110609091705.GA2190@mail.fossee.in>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Thu, 9 Jun 2011 14:43:03 +0530
Message-ID: <BANLkTin74+ryVSjsfk=f789bYVjk_0Pqzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: comedi: add dyna_pci10xx0 driver to Makefile
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 9, 2011 at 2:47 PM, Prashant P. Shah <pshah.mumbai@gmail.com> wrote:
> Add dyna_pci10xx0 entry to comedi Kconfig and Makefile

Please use the patches that I have resend. I made a spelling mistake
in the commit message (extra 0 in the dyna_pci10xx0 name)

Thanks.
