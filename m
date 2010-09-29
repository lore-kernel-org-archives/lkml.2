Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0I2LH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:07:29 -0400
Received: from mail.southpole.se ([193.12.106.18]:52665 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0I2LH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:07:28 -0400
Subject: Re: ioremap definition in generic io.h
From: Jonas Bonn <jonas@southpole.se>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4CA31AA6.7020003@gmail.com>
References: <1285747145.12259.3.camel@needafix> <4CA31AA6.7020003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Wed, 29 Sep 2010 13:07:26 +0200
Message-ID: <1285758446.12259.9.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 12:53 +0200, Jiri Slaby wrote:
> On 09/29/2010 09:59 AM, Jonas Bonn wrote:
> > I'm wondering about the usefulness of the definition of ioremap and
> > __ioremap in asm-generic/io.h.  How is this intended to be used?  How
> > are the page tables for this mapping supposed to be constructed?
> 
> Which page tables? The functions there are for machines w/o MMU with 1:1
> phys:virt mapping.
> 

OK, thanks.  It's not clear from asm-generic/io.h that it's intended for
NOMMU systems only.  Aside from the ioremap definition, everything in
that file should be applicable generically... or am I missing something?

On another note, looking at the definitions of ioread32/iowrite32, they
imply a little-endian bus.  Some architectures (e.g. Microblaze) define
these to use host-native byte ordering instead.  Is there a _correct_
way these functions should be defined?

/Jonas


