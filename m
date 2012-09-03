Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2ICFXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:23:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64367 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2ICFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:23:23 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-2-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-2-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:23:21 +0300
X-Google-Sender-Auth: aRL7elDzazJHRXz0jCa5aUy1t8M
Message-ID: <CAOJsxLFrTMWmsVwx_1URt-OmUGq=C36vUyi4DoWt-8L-ii-O5Q@mail.gmail.com>
Subject: Re: [PATCH -v2 01/13] x86, mm: Add global page_size_mask
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
> detect if need to use 1G or 2M and store them in page_size_mask.
>
> Only probe them one time.
>
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
