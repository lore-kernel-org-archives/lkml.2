Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2FEXsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:48:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60309 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2FEXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:48:22 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE8307.3050901@linux.intel.com>
References: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com>
	<CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com>
	<4FC90BAD.3080606@linux.intel.com>
	<4FCE8307.3050901@linux.intel.com>
Date: Wed, 6 Jun 2012 08:48:20 +0900
Message-ID: <CANKRQnj5mxHLprMt4VMMa7sCwLZb=PAktnVVD1MZVkkUG4eLoA@mail.gmail.com>
Subject: Re: [RFC PATCH] pch_uart: Add eg20t_port lock field, avoid recursive spinlocks
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 7:07 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> Are there still concerns about the additional lock? I'll resend V2
> tomorrow with the single whitespace fix if I don't hear anything back today.

I understand your saying. Looks good.
However, I am not expert of linux-uart core system.
So, I'd like UART maintainer to give us your opinion.

thanks.
tomoya
