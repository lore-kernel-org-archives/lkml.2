Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1AaTac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:30:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab1AaTab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:30:31 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blkio-throttle: Avoid calling blkiocg_lookup_group() for root group
References: <20110117215606.GI5624@redhat.com>
	<20110126185729.GD6713@redhat.com>
	<x49ei7sq3qe.fsf@segfault.boston.devel.redhat.com>
	<4D470C50.6010701@kernel.dk> <4D470CA7.7020508@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 31 Jan 2011 14:30:25 -0500
In-Reply-To: <4D470CA7.7020508@fusionio.com> (Jens Axboe's message of "Mon, 31
	Jan 2011 20:25:27 +0100")
Message-ID: <x49aaigq3am.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

>> Yep, will fold it into 2.6.38, thanks!

Awesome, thanks Jens!

-Jeff
