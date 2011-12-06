Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab1LFOCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:02:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51324 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab1LFOCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:02:33 -0500
MIME-Version: 1.0
X-Originating-IP: [62.165.247.249]
In-Reply-To: <1322600880.1534.345.camel@localhost.localdomain>
References: <1322600880.1534.345.camel@localhost.localdomain>
Date: Tue, 6 Dec 2011 15:02:31 +0100
Message-ID: <CAJfpegu8fXudxaps10egnq6zcULTZh6EAQ8pA2osTM8zSwQ8rw@mail.gmail.com>
Subject: Re: [PATCH] fuse: Use kcalloc instead of kzalloc to allocate array
From: Miklos Szeredi <miklos@szeredi.hu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:08 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
>
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Thanks,  applied.

Miklos
