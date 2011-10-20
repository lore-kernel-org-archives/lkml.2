Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1JTRDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:03:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64975 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1JTRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:03:42 -0400
Message-ID: <4EA0546C.6060303@garzik.org>
Date: Thu, 20 Oct 2011 13:03:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Christian T. Steigies" <cts@debian.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2011.bluespice.org>
Subject: Re: [PATCH 4/4] fbdev/cirrusfb: Add support for "64 MiB" version
 of Picasso IV
References: <1319110945-25684-1-git-send-email-geert@linux-m68k.org> <1319110945-25684-4-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1319110945-25684-4-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 07:42 AM, Geert Uytterhoeven wrote:
> Some Village Tronic Picasso IV graphics cards identify as a 64 MiB Zorro
> device in Zorro III mode.
>
> While the total graphics memory size is the same on such cards, the offset
> of the graphics memory differs. Add a quirk to handle this.
>
> Based on src/sys/arch/amiga/dev/grf_cl.c from NetBSD.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Jeff Garzik <jgarzik@redhat.com>



