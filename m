Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab1JEKmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:42:13 -0400
Received: from h1778886.stratoserver.net ([85.214.133.74]:39526 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571Ab1JEKmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:42:12 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] regulator: Add driver for gpio-controlled regulators
Date: Wed, 5 Oct 2011 12:42:11 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
References: <201110051227.05717.heiko@sntech.de> <20111005102835.GC9783@opensource.wolfsonmicro.com>
In-Reply-To: <20111005102835.GC9783@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110051242.11713.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Oktober 2011, 12:28:35 schrieben Sie:
> On Wed, Oct 05, 2011 at 12:27:05PM +0200, Heiko Stübner wrote:
> > This patch adds support for regulators that can be controlled via gpios.
> 
> How does this differ from the v2 of your patch that you sent at Tue, 4
> Oct 2011 21:34:42 +0200?
as I wrote in the changes section, it is a resend, as I included the wrong 
list (linux-arm-kernel instead of linux-kernel).

There are no code changes.

Heiko
