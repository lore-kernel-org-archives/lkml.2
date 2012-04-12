Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965723Ab2DLSQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:16:33 -0400
Received: from mail.tomasu.net ([64.85.170.232]:39106 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021Ab2DLSQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:16:32 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: adam radford <aradford@gmail.com>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Thu, 12 Apr 2012 12:16:24 -0600
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
References: <201203211716.45418.thomas@fjellstrom.ca> <201204111544.27866.thomas@fjellstrom.ca> <CAHtARFHayv68BASrfCLYHQ0zZ1R8fvzfB-_fkBeG8H4g3OBZvg@mail.gmail.com>
In-Reply-To: <CAHtARFHayv68BASrfCLYHQ0zZ1R8fvzfB-_fkBeG8H4g3OBZvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204121216.24519.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Apr 12, 2012, adam radford wrote:
> On Wed, Apr 11, 2012 at 2:44 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> 
wrote:
> > megasas: [55] waiting for 1 commands to complete
> > ....
> > megasas: [175] waiting for 1 commands to complete
> 
> You still aren't getting interrupts from the card.  Can you re-try
> with megaraid_sas module parameter msix_disable ?
> If that doesn't work, contact LSI support and tell them which
> motherboard, any PCIe bridges, risers, etc you have.

No luck darn it. with either card.

> -Adam


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
