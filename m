Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1K3JOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:14:38 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59602 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab1K3JOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:14:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Haogang Chen <haogangchen@gmail.com>
Subject: Re: [PATCH] Media: video: uvc: integer overflow in uvc_ioctl_ctrl_map()
Date: Wed, 30 Nov 2011 10:14:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1322602345-26279-1-git-send-email-haogangchen@gmail.com> <201111300222.42162.laurent.pinchart@ideasonboard.com> <CAHrvArQy2N4jUBQpBG+mey9KE412cURK9CU=1xZ_xodA_Vb8Jw@mail.gmail.com>
In-Reply-To: <CAHrvArQy2N4jUBQpBG+mey9KE412cURK9CU=1xZ_xodA_Vb8Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301014.41810.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haogang,

On Wednesday 30 November 2011 03:28:32 Haogang Chen wrote:
> The hard limit sounds good to me.

OK.

> But if you want to centralize error handling, please make sure that "goto
> done" only frees map, but not map->menu_info in that case.

map->menu_info will be NULL, so it's safe to kfree() it.

-- 
Regards,

Laurent Pinchart
