Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2BBJqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:46:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53002 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2BBJqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:46:05 -0500
Date: Thu, 2 Feb 2012 10:46:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Mendelsohn <mendelso@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: H5 Line Discipline for Bluetooth
Message-ID: <20120202094603.GA1643@atrey.karlin.mff.cuni.cz>
References: <C27F8246C663564A84BB7AB34397724266D8EE3FB1@IRVEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C27F8246C663564A84BB7AB34397724266D8EE3FB1@IRVEXCHCCR01.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From ab30529d2c1d32dd397e4e5c165572a2ab43f597 Mon Sep 17 00:00:00 2001
> From: Mark P. Mendelsohn <mpm>
> Date: Wed, 10 Aug 2011 14:26:34 -0700
> Subject: [PATCH 01/10] adding H5
> 
> ---
>  drivers/bluetooth/1           |  812 ++++++++++++++++++++++++++++++++++++++++
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/hci_h5.c    |  817 +++++++++++++++++++++++++++++++++++++++++
>  drivers/bluetooth/hci_ldisc.c |   32 +-
>  drivers/bluetooth/hci_uart.h  |    8 +-
>  6 files changed, 1669 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/bluetooth/1
>  create mode 100644 drivers/bluetooth/hci_h5.c

What about somedescription what h5 is in the changelog?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
