Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2KUHk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:40:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44655 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2KUHk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:40:58 -0500
MIME-Version: 1.0
In-Reply-To: <1353482170-10160-6-git-send-email-yinghai@kernel.org>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-6-git-send-email-yinghai@kernel.org>
Date: Wed, 21 Nov 2012 09:40:56 +0200
X-Google-Sender-Auth: aYAmsQ9gjA8wb-Xy4qbh_8TFJN8
Message-ID: <CAOJsxLFdXDUOjeoL7F2mzfg_eEB+uPAPzP8jFGNeXEfx0vc0Qg@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] x86: Merge early_reserve_initrd for 32bit and 64bit
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 9:16 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> They are the same, could move them out from head32/64.c to setup.c.
>
> We are using memblock, and it could handle overlapping properly, so
> we don't need to reserve some at first to hold the location, and just
> need to make sure we reserve them before we are using memblock to find
> free mem to use.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
