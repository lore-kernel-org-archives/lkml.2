Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422666Ab2JLMM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:12:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34670 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977Ab2JLMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121004102013.GA23284@lizard>
References: <20121004102013.GA23284@lizard>
Date: Fri, 12 Oct 2012 15:12:55 +0300
X-Google-Sender-Auth: jcXQ4v4LPfOqJL4RtszjxOjOIXc
Message-ID: <CAOJsxLF8qc-_YWiUaNz2FPKF2pds8J2P=NbrBZnD2eHB=s3jzA@mail.gmail.com>
Subject: Re: [PATCH 0/3] A few cleanups and refactorings, sync w/ upstream
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Thu, Oct 4, 2012 at 1:20 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Hello Pekka,
>
> Just a few updates to vmevents:
>
> - Some cleanups and refactorings -- needed for easier integration of
>   'memory pressure' work;
> - Forward to newer Linus' tree, fix conflicts.

Applied, thanks!
