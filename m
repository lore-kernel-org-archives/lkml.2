Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2ICFYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:24:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2ICFYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-4-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-4-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:24:37 +0300
X-Google-Sender-Auth: vp2pbdOssoRDozuvkutgqirS9Qk
Message-ID: <CAOJsxLFPsdLcCFX3uz=K06Dd47YJEycdy4+t_0QmY=6wCb_DSw@mail.gmail.com>
Subject: Re: [PATCH -v2 03/13] x86, mm: Moving init_memory_mapping calling
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> from setup.c to mm/init.c
>
> So could update all related calling together later
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
