Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023Ab2ERNLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:11:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59709 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933744Ab2ERNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205171329440.12366@router.home>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com>
	<1337269668-4619-5-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1205171329440.12366@router.home>
Date: Fri, 18 May 2012 22:11:06 +0900
Message-ID: <CAAmzW4Py8-UQmTcgfXzszco=FqGd-FGPA4qMKAmt70NtFwgpQA@mail.gmail.com>
Subject: Re: [PATCH 4/4] slub: refactoring unfreeze_partials()
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/18 Christoph Lameter <cl@linux.com>:
> The reason the current implementation is so complex is to avoid races. The
> state of the list and the state of the partial pages must be consistent at
> all times.
OK. I got it.

> Looks good. If I can convince myself that this does not open up any
> new races then I may ack it.
Thanks.
