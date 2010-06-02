Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab0FBUTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:19:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36962 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab0FBUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i5MhmLmcO5JaLXqbAZZalUDKtK2NZFfRjFOfpHGeO+Le6gtRkQHvsCpxuaVSv+XaXu
         9a8815+nwcPnbgsYPctpI53siiCVx7AHqe8u2CKaY/rqtK8lAf3qAS90V2SFf8bYw2k8
         TMnKUPr3ztnrRXJrVuohdjw7bXG/5e2LhQHrI=
Subject: Re: strange problem with ricoh-mmc
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <04b98a3f757587ee9b72f2e28e257b50@localhost>
References: <1275505018.4215.10.camel@maxim-laptop>
	 <04b98a3f757587ee9b72f2e28e257b50@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 23:19:25 +0300
Message-ID: <1275509965.6277.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 15:54 -0400, Philip Langdale wrote: 
> On Wed, 02 Jun 2010 21:56:58 +0300, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> > Hi,
> > 
> > Maybe this is my fault, don't know, but I found and now confident that
> > new and possible old version of ricoh-mmc causes troubles after
> > suspend/resume.
> > 
> > Namely there are two problems.
> > One is that sometimes card detection on xD controller stops working.
> > That is it doesn't respond to insert/remove events, and suspend to ram
> > just updates that once. Granted I wrote this driver, but it appears to
> > work without richoh-mmc.
> > 
> > Another problem that is unrelated to xD is that sometimes sdhci
> > conroller issues an interrupt storm, and does so until its driver is
> > reloaded. At that point it refuses to load with missing voltage levels.
> > 
> > I never seen these without ricoh-mmc pci quirk.
> > 
> > Both problems are semi-rare.
> > 
> > So just one question, did you see these problems?
> > Do you have a clue on how to proceed?
> 
> I have never seen these problems, but I could imagine that perhaps the
> PCI register pokes have side-effects or there's actually more that needs
> to be done than what we currently have. No one has access to the relevant
> datasheets so the magic incantations are second hand. More worryingly, it
> may not be a well supported configuration - while the other controllers
> might be disabled based on physical slot design, SD and MMC are the same,
> so I doubt Ricoh or OEMs have ever seriously considered having only one
> on. I've not heard of the sdhci problem before - maybe your hardware is
> dodgy? :-)


Thanks.
I some future I maybe consider reverse engineering  the MMC controller.

Best regards,
Maxim Levitsky

