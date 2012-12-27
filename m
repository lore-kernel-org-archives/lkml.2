Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2L0KR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 05:17:59 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63402 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2L0KR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 05:17:57 -0500
MIME-Version: 1.0
In-Reply-To: <1354568322-29029-5-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
	<1354568322-29029-5-git-send-email-koverstreet@google.com>
Date: Thu, 27 Dec 2012 11:11:12 +0100
Message-ID: <CAJAFBLCw3BBz3G81qgcnHKDf2nML900CZqxooGqBioRpun9W_A@mail.gmail.com>
Subject: Re: [PATCH 04/26] aio: remove retry-based AIO
From: Fubo Chen <fubo.chen@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:58 PM, Kent Overstreet <koverstreet@google.com> wrote:
> We want to remove retry-based AIO because it is fundemantally unsafe.

Instead of "fundemantally" that should have been "fundamentally" I guess ?

Thanks,

Fubo.
