Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830Ab1JFLYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:24:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60254 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1JFLY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:24:29 -0400
MIME-Version: 1.0
In-Reply-To: <19809.1317842403@turing-police.cc.vt.edu>
References: <20111005182503.GA6142@google.com>
	<19809.1317842403@turing-police.cc.vt.edu>
Date: Thu, 6 Oct 2011 13:22:23 +0200
Message-ID: <CANGUGtASfUfd2-ndRr0h27-LO6tXXCNk5kiytEmkh40pAKUcuA@mail.gmail.com>
Subject: Re: [PATCH] ramoops: scripts/ramoops.c for extracting oopses
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Thomas Tuttle <ttuttle@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/10/5  <Valdis.Kletnieks@vt.edu>:
> On Wed, 05 Oct 2011 14:25:03 EDT, Thomas Tuttle said:
>> Add a C program to extract oopses stored by ramoops.  Running with no
>> arguments will list all of the records; running with an argument number
>> will retrieve the oops from that record, if it is valid.
>
>> + * ramoops: Extract ramoops images from /dev/mem.
>
> How does this play with CONFIG_STRICT_DEVMEM?
>

It's be a problem only if the driver uses ioremap exclusive, but it doesn't.

Marco
