Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2BAHcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:32:53 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44359 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab2BAHcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:32:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120201063420.GA10204@darkstar.nay.redhat.com>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
Date: Wed, 1 Feb 2012 09:32:52 +0200
X-Google-Sender-Auth: GFL_0ZPEFxg7Eqpl1dIR767tHU4
Message-ID: <CAOJsxLGVS3bK=hiKJu4NwTv-Nf8TCSAEL4reSZoY4=44hPt8rA@mail.gmail.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
From: Pekka Enberg <penberg@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 8:34 AM, Dave Young <dyoung@redhat.com> wrote:
> tools/ is the better place for vm tools which are used by many people.
> Moving them to tools also make them open to more users instead of hide in
> Documentation folder.

For moving the code:

Acked-by: Pekka Enberg <penberg@kernel.org>

> Also fixed several coding style problem.

Can you please make that a separate patch?
