Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab0LTPOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:14:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0LTPOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:14:52 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 4/4] Staging: zram: simplify zram_make_request
References: <4D0B88E5.4040005@redhat.com> <4D0B89F7.1000103@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 20 Dec 2010 10:14:47 -0500
In-Reply-To: <4D0B89F7.1000103@redhat.com> (Jerome Marchand's message of "Fri,
	17 Dec 2010 17:04:07 +0100")
Message-ID: <x497hf4xyqg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Marchand <jmarchan@redhat.com> writes:

> zram_read() and zram_write() always return zero, so make them return
> void to simplify the code.
>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
