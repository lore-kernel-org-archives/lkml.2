Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2KGN3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:29:25 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39020 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2KGN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:29:23 -0500
Date: Wed, 7 Nov 2012 08:28:20 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/21] omfs: drop vmtruncate
Message-ID: <20121107132820.GA26326@localhost>
References: <5094E2EA.3090505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5094E2EA.3090505@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 10:24:58AM +0100, Marco Stornelli wrote:
> Removed vmtruncate
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Thanks!

Acked-by: Bob Copeland <me@bobcopeland.com>

> ---
>  fs/omfs/file.c |   22 +++++++++++++++-------
>  1 files changed, 15 insertions(+), 7 deletions(-)

-- 
Bob Copeland %% www.bobcopeland.com
