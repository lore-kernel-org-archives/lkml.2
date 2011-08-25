Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1HYMBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:01:02 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:32813 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1HYMBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:01:00 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 08:01:00 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 25 Aug 2011 13:52:10 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/14] [media] winbond-cir: Use current logging styles
In-Reply-To: <90e0dd84ad9404a4d6377d05a86c9ae60918ccda.1313966089.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com> <90e0dd84ad9404a4d6377d05a86c9ae60918ccda.1313966089.git.joe@perches.com>
Message-ID: <4056b67ddb72b944705f09dba2f00a62@hardeman.nu>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: David Härdeman <david@hardeman.nu>

On Sun, 21 Aug 2011 15:56:47 -0700, Joe Perches <joe@perches.com> wrote:
> Add pr_fmt, convert printks to pr_<level>.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/rc/winbond-cir.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

