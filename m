Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1LWLSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:18:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55577 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706Ab1LWLSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:18:11 -0500
Date: Fri, 23 Dec 2011 11:18:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: arnd@arndb.de, greg@kroah.com, eric.piel@tremplin-utc.net,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Message-ID: <20111223111807.GH2834@opensource.wolfsonmicro.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:54:52AM +0530, AnilKumar Ch wrote:
> This patch adds support for lis33ldlh digital accelerometer to the
> lis3lv02d driver family. Adds ID field for detecting the lis33ldlh
> module, based on this ID field lis3lv02d driver will export the
> lis33ldlh module functionality.

You shouldn't send cover letters for single patches, if there's anything
that needs saying it should be in the changelog for the patch.
