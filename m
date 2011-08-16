Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1HPIPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 04:15:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43238 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1HPIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 04:15:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH 05/11] drivers/media: do not use EXTRA_CFLAGS
Date: Tue, 16 Aug 2011 10:15:49 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com> <1313384834-24433-6-git-send-email-lacombar@gmail.com>
In-Reply-To: <1313384834-24433-6-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161015.49608.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,

On Monday 15 August 2011 07:07:08 Arnaud Lacombe wrote:
> Usage of these flags has been deprecated for nearly 4 years by:
> 
>     commit f77bf01425b11947eeb3b5b54685212c302741b8
>     Author: Sam Ravnborg <sam@neptun.(none)>
>     Date:   Mon Oct 15 22:25:06 2007 +0200
> 
>         kbuild: introduce ccflags-y, asflags-y and ldflags-y
> 
> Moreover, these flags (at least EXTRA_CFLAGS) have been documented for
> command line use. By default, gmake(1) do not override command line
> setting, so this is likely to result in build failure or unexpected
> behavior.
> 
> Replace their usage by Kbuild's `{as,cc,ld}flags-y'.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org

For drivers/media/video/omap3isp/Makefile,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
