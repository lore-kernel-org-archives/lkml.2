Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab1BPHtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:49:41 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:39699 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757460Ab1BPHti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:49:38 -0500
Date: Wed, 16 Feb 2011 08:29:02 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cs: housekeeping
Message-ID: <20110216072902.GA27847@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201102071151.08396.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102071151.08396.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 11:51:07AM +0100, Bartlomiej Zolnierkiewicz wrote:
> * remove needless includes
> * remove stale comments
> * remove struct ide_info_t
> * remove legacy dev_dbg() debugging
> * inline ide_{config,release}()
> 
> Compile-tested only.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net> [pcmcia parts]

Best,
	Dominik
