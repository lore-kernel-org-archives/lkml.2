Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2ICF2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:28:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55097 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2ICF2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-7-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-7-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:28:14 +0300
X-Google-Sender-Auth: mKhLDceqihaDKZ0RLdNMrM7ssDs
Message-ID: <CAOJsxLGNcyg=X2RNydmxfEPnWiZyiHX8Z7qtu3Cjuw3xTE4zTQ@mail.gmail.com>
Subject: Re: [PATCH -v2 06/13] x86, mm: Separate out calculate_table_space_size()
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
> it should take physical address range that will need to be mapped.
> and find_early_table_space should take range that pgt buff should be in.
> Separate those two to reduce confusion.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
