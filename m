Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1H3WTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:19:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53807 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1H3WTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:19:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: BUG: unable to handle kernel paging request at 6b6b6bcb (v4l2_device_disconnect+0x11/0x30)
Date: Wed, 31 Aug 2011 00:20:10 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.7.0; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20110829204846.GA14699@sucs.org>
In-Reply-To: <20110829204846.GA14699@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108310020.10493.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 29 August 2011 22:48:46 Sitsofe Wheeler wrote:
> Hi,
> 
> I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by unplugging a
> USB webcam.

Thanks for the report. Can you reproduce this on v3.0 ? What were the exact 
steps that led to the crash ?

-- 
Regards,

Laurent Pinchart
