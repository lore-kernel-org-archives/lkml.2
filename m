Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1KCLSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:18:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64433 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1KCLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <1320107362.22361.185.camel@sli10-conroe>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
	<CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
	<CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
	<1319676161.22361.148.camel@sli10-conroe>
	<CADAg6uy2xOoAaAhVg07oYia+AZAuOGKywPGx8fvT0EF4ThuKCQ@mail.gmail.com>
	<1320039564.22361.178.camel@sli10-conroe>
	<CANejiEVxdX7KC6MFqBZ2azPtETmwJXML6v1L5-kq+UrRTmf+Tg@mail.gmail.com>
	<CADAg6uwi8bgo3gQuWPeTHeD44biRR4=0E0BjvZradQMtfMCigA@mail.gmail.com>
	<1320107362.22361.185.camel@sli10-conroe>
Date: Thu, 3 Nov 2011 16:48:09 +0530
Message-ID: <CADAg6uy_7GyB9Zm+aO1v-4t1FiMdRO2Q7KkqOU4XGtcfX1BBCQ@mail.gmail.com>
Subject: Re: Multi-partition block layer behaviour
From: Tiju Jacob <jacobtiju@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> please ignore the patch. There is a fix in upstream:
> 9c40cef2b799f9b5e7fa5de4
> and it's marked -stable, so it will go to 3.0 stable.
> if 3.1 kernel doesn't work, please report back with a log.
>
Thanks Shaohua. We tried with 3.0.8 and 3.1. It works fine.

--TJ
