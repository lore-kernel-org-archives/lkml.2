Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1LLVTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:19:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49546 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab1LLVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:19:46 -0500
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Scott Wood <scottwood@freescale.com>
Cc: shuo.liu@freescale.com, dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Date: Mon, 12 Dec 2011 23:19:37 +0200
In-Reply-To: <4EE66EFE.1050608@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	  <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	  <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>
	 <4EE66EFE.1050608@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323724784.2297.20.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 15:15 -0600, Scott Wood wrote:
> NAND chips come from the factory with bad blocks marked at a certain
> offset into each page.  This offset is normally in the OOB area, but
> since we change the layout from "4k data, 128 byte oob" to "2k data, 64
> byte oob, 2k data, 64 byte oob" the marker is no longer in the oob.  On
> first use we need to migrate the markers so that they are still in the oob.

Ah, I see, thanks. Are you planning to implement in-kernel migration or
use a user-space tool?

Artem.

