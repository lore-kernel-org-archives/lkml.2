Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2FLME1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:04:27 -0400
Received: from fallback1.mail.ru ([94.100.176.18]:54617 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2FLME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:04:26 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2012 08:04:25 EDT
Message-ID: <4FD72BE2.2030804@inbox.ru>
Date: Tue, 12 Jun 2012 13:45:38 +0200
From: Dmitry Artamonow <mad_soft@inbox.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: remove linkup-l1110.h
References: <1339495469.30984.115.camel@x61.thuisdomein>
In-Reply-To: <1339495469.30984.115.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 12:04 PM, Paul Bolle wrote:
> No file includes this header. Nothing seems interested in the things
> this header provides. It appears that it has never been included since
> at least v2.6.12-rc2. It can safely be removed.
>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> Tested by "git grepping" the (history of) the tree for a few things.
>
>   arch/arm/include/asm/hardware/linkup-l1110.h |   48 --------------------------
>   1 files changed, 0 insertions(+), 48 deletions(-)
>   delete mode 100644 arch/arm/include/asm/hardware/linkup-l1110.h
>
These are the definitions for chip which is used on 2-slot CF/PCMCIA
extension "jackets" on iPaq h3100/h3600. Currently h3600 PCMCIA driver
doesn't support such 2-slot "jackets", so yes, this header can be removed.

You can add my
Acked-by: Dmitry Artamonow <mad_soft@inbox.ru>
if you like.

Thanks for cleaning it up!

--
Best regards,
Dmitry "MAD" Artamonow
