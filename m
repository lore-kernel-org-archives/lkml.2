Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2HSXFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 19:05:17 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:35031 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2HSXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 19:05:12 -0400
Message-ID: <1345417456.5651.4.camel@obelisk.thedillows.org>
Subject: Re: [PATCH 7/9] sound/pci/sis7019.c: fix error return code
From: David Dillow <dave@thedillows.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jaroslav Kysela <perex@perex.cz>, kernel-janitors@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Sun, 19 Aug 2012 19:04:16 -0400
In-Reply-To: <1345359780-18647-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1345359780-18647-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 09:02 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Initialize rc before returning on failure, as done elsewhere in the
> function.

> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: David Dillow <dave@thedillows.org>

