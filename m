Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966364Ab0GSTAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965169Ab0GSTAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:00:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 3/3] cfq-iosched: Print per slice sectors dispatched in blktrace
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
	<1279560008-2905-4-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 19 Jul 2010 14:59:59 -0400
In-Reply-To: <1279560008-2905-4-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 19 Jul 2010 13:20:08 -0400")
Message-ID: <x49eiezthzk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> - Divyesh had gotten rid of this code in the past. I want to re-introduce it
>   back as it helps me a lot during debugging.

Fine with me.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
