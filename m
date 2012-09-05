Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2IEIDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:03:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59538 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2IEIC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <1346823991-22911-14-git-send-email-yinghai@kernel.org>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
	<1346823991-22911-14-git-send-email-yinghai@kernel.org>
Date: Wed, 5 Sep 2012 11:02:58 +0300
X-Google-Sender-Auth: YYk81H_n5KiJ1fxT1tpag0DjTIc
Message-ID: <CAOJsxLHRPxKoCSTHVgvzXR+si8TWqD2Sa0aNS6qLXPrwhCdU=w@mail.gmail.com>
Subject: Re: [PATCH -v3 13/14] x86, mm: Use func pointer to table size
 calculation and mapping
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 8:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> They all need to go over ram range in same sequence. So add shared function
> to reduce duplicated code.
>
> -v2: Change to walk_ram_ranges() according to Pekka Enberg.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
