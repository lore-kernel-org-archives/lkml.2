Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0LPXs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:48:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab0LPXs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:48:27 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: remove unnecessary check
References: <1292490545-6071-1-git-send-email-namhyung@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 16 Dec 2010 18:48:22 -0500
In-Reply-To: <1292490545-6071-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Thu, 16 Dec 2010 18:09:05 +0900")
Message-ID: <x4962ut6zzt.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:

> 'nr >= min_nr >= 0' always satisfies 'nr >= 0' so the check is unnecesary.

Yeah, I don't see how the extra check helps.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
