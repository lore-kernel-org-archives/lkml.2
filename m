Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1ECNWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:22:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1ECNWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <4DBFADBE.5040603@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de> <1300782452-528-1-git-send-email-hs@denx.de>
 <20110502221406.GA15043@ponder.secretlab.ca> <4DBF8FF6.8030100@denx.de>
 <BANLkTimacM29RHExZounuziF+7jARQxdTg@mail.gmail.com> <4DBFADBE.5040603@denx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 3 May 2011 07:22:20 -0600
X-Google-Sender-Auth: auwV429-7PKWGIRVwvuYDAPxHpk
Message-ID: <BANLkTi=b_ySGOxb2jXCvKdniesdNhqoUpQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] powerpc, 52xx: add charon board support
To: hs@denx.de
Cc: linuxppc-dev@lists.ozlabs.org, Wolfram Sang <w.sang@pengutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 1:24 AM, Heiko Schocher <hs@denx.de> wrote:
>
> Ok. Done, just one more question:
>
> Why you didn;t pick up the patches:
>
> - powerpc, 5200: add support for charon board
>  (Got an Acked-by from Wolfram Sang)
> - powerpc, video: add SM501 support for charon board.

I did pick them up and they are in my tree.  Actually, I squashed
those two together since there was no reason to have them split apart.

g.
