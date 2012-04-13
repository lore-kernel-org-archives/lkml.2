Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2DMSuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:50:16 -0400
Received: from mail.tomasu.net ([64.85.170.232]:45499 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab2DMSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:50:14 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: adam radford <aradford@gmail.com>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Fri, 13 Apr 2012 12:50:05 -0600
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
References: <201203211716.45418.thomas@fjellstrom.ca> <CAHtARFHayv68BASrfCLYHQ0zZ1R8fvzfB-_fkBeG8H4g3OBZvg@mail.gmail.com> <201204121216.24519.thomas@fjellstrom.ca>
In-Reply-To: <201204121216.24519.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204131250.05970.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Apr 12, 2012, Thomas Fjellstrom wrote:
> On Thu Apr 12, 2012, adam radford wrote:
> > On Wed, Apr 11, 2012 at 2:44 PM, Thomas Fjellstrom <thomas@fjellstrom.ca>
> 
> wrote:
> > > megasas: [55] waiting for 1 commands to complete
> > > ....
> > > megasas: [175] waiting for 1 commands to complete
> > 
> > You still aren't getting interrupts from the card.  Can you re-try
> > with megaraid_sas module parameter msix_disable ?
> > If that doesn't work, contact LSI support and tell them which
> > motherboard, any PCIe bridges, risers, etc you have.
> 
> No luck darn it. with either card.

I've been talking to LSI support for the past few days. So far they are 
unwilling to support my current use case, or fix their INT19 firmware bug (which 
they have acknowledged).

I just hope there aren't any more serious bugs like this in their firmware. 
It's looking pretty scary. If they let this bug live for years, imagine what 
other bugs might lurk. I may have to avoid LSI completely in the future, even 
on real server systems.

> > -Adam


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
