Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2LASbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:31:15 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40484 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2LASbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:31:09 -0500
MIME-Version: 1.0
In-Reply-To: <50B9F233.5040902@gentoo.org>
References: <50B9F233.5040902@gentoo.org>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Sat, 1 Dec 2012 12:30:48 -0600
Message-ID: <CAAMCDefRCdB1oLGmXxoChzqhoYKK8y4LZ5pOQVN1Uriz514_3w@mail.gmail.com>
Subject: Re: My SD Card Reader cannot read SDHC cards
To: kernel@gentoo.org
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 6:04 AM, Richard Yao <ryao@gentoo.org> wrote:
> Standard Microsystems Corp. 8-in-1 Card
> Reader

Does that card reader support SDHC cards?    The older readers don't
support >2GB (ie sdhc)
cards, and that would mean a 2GB card works and the 4GB or larger ones won't.
