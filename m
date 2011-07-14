Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1GNRQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:16:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57693 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab1GNRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <4E1DB7A5.7040708@redhat.com>
References: <4E1DB7A5.7040708@redhat.com>
Date: Thu, 14 Jul 2011 10:16:48 -0700
Message-ID: <CAPkvG_fwwD7Gg88SjbQ_NWFT31GNnDCP6ud=pb6MERLqUHiyRg@mail.gmail.com>
Subject: Re: [PATCH] Staging: zram: Fix kunmapping order
From: Nitin Gupta <ngupta@vflare.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 8:20 AM, Jerome Marchand <jmarchan@redhat.com> wrote:
>
> This patch fixes the unmapping order of KM_USER0/1 in
> handle_uncompressed_page() and zram_read() so that kmap()/kunmap() calls
> are correctly nested.
>
> Reported-by: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Thanks for the fix.

Reviewed-by: Nitin Gupta <ngupta@vflare.org>

Nitin
