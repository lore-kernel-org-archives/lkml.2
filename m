Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2FOMMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:12:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61320 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2FOMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <201206151207.07108.arnd@arndb.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
	<201206151207.07108.arnd@arndb.de>
Date: Fri, 15 Jun 2012 09:12:37 -0300
Message-ID: <CAAAP30HU7k2QC9K15V3grZvXDzy8apzBGSo8it+M4KF5wGWLZw@mail.gmail.com>
Subject: Re: [PATCH v2 00/23] ARM: LPC32xx specific updates for next
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roland Stigge <stigge@antcom.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 9:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> It all looks good from my point of view, so I think we can pull it
> for 3.6 if no other comments come.

Arn,

Please exclude "ARM: LPC32xx: Remove duplicate usb host clock init".
It's causing problems in some LPC32XX boards.
