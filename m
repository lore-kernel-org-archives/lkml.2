Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0CZV53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:57:29 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:35756 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0CZV52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <20100326181800.GB21682@n2100.arm.linux.org.uk>
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<20100324230729.GA21359@n2100.arm.linux.org.uk> <4BAB38B1.8080404@ru.mvista.com> 
	<20100326181800.GB21682@n2100.arm.linux.org.uk>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Fri, 26 Mar 2010 18:57:07 -0300
Message-ID: <cecb6d8f1003261457x69c319c1w884ade1746f81e8b@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in soc_common.c
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
       linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 15:18, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Mar 25, 2010 at 01:19:29PM +0300, Sergei Shtylyov wrote:
>>
>>   I'd disagree in this case. Anybody will hardly grep for "mask:
>> %s%s%s%s%s%sflags: %s%s%s%s%s%s".
>
> Well, I disagree on a matter of principle with you.  If you want to avoid
> the line going over 80 columns, move the entire string onto the next line.
> Then we can have the entire string intact _and_ we can have it fitting
> within 80 columns.

This is no big deal. Also, I have already submitted the new patch and
Valdis had a good point for egrep.

Regards,
Marcelo.
