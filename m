Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2DLILk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:11:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:32784 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2DLILd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <201204111544.27866.thomas@fjellstrom.ca>
References: <201203211716.45418.thomas@fjellstrom.ca>
	<201204111417.28893.thomas@fjellstrom.ca>
	<CAHtARFERLPA345Qsp=-_+5BGAdOrLaJ+HLGzqENBFNRXNJMDhg@mail.gmail.com>
	<201204111544.27866.thomas@fjellstrom.ca>
Date: Thu, 12 Apr 2012 01:11:32 -0700
Message-ID: <CAHtARFHayv68BASrfCLYHQ0zZ1R8fvzfB-_fkBeG8H4g3OBZvg@mail.gmail.com>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
From: adam radford <aradford@gmail.com>
To: thomas@fjellstrom.ca
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 2:44 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> megasas: [55] waiting for 1 commands to complete
> ....
> megasas: [175] waiting for 1 commands to complete

You still aren't getting interrupts from the card.  Can you re-try
with megaraid_sas module parameter msix_disable ?
If that doesn't work, contact LSI support and tell them which
motherboard, any PCIe bridges, risers, etc you have.

-Adam
