Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1GEKeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:34:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab1GEKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110705133240.25e81a7a@kryten>
References: <20110705133240.25e81a7a@kryten>
Date: Tue, 5 Jul 2011 18:34:34 +0800
Message-ID: <CAM_iQpU=3CxbTvsieFbkcx6QT82WRqqkeAJcvN6nDximtYdDhQ@mail.gmail.com>
Subject: Re: [PATCH] lockup detector: CONFIG_DETECT_SOFTLOCKUP no longer exists
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: fweisbec@gmail.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 11:32 AM, Anton Blanchard <anton@samba.org> wrote:
>
> Replace CONFIG_DETECT_SOFTLOCKUP with CONFIG_LOCKUP_DETECTOR.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>

Good catch!

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
