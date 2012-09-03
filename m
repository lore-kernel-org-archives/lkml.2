Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2ICFXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:23:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60346 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2ICFXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-3-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-3-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:23:53 +0300
X-Google-Sender-Auth: 0LfDTFJ3FxXFlTU_ffjJ6MO-q4Q
Message-ID: <CAOJsxLFOOkOHxAeoFrjGrmkAC6mOySp9WaO8Az96d_JOoBQvGg@mail.gmail.com>
Subject: Re: [PATCH -v2 02/13] x86, mm: Split out split_mem_range
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
> from init_memory_mapping, so make init_memory_mapping readable.
>
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
