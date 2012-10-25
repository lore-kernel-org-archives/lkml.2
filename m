Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab2JYCJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:09:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47919 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2JYCJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <1351115423-9025-13-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org> <1351115423-9025-13-git-send-email-acme@infradead.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 25 Oct 2012 11:09:06 +0900
X-Google-Sender-Auth: 1uO-de2DAwOEX7HYflRw3qMVxZI
Message-ID: <CAM9d7cjwX=2FnaM4CK_c9_UKOJvg-5JUOGqx-EcdhRbRA2yPDg@mail.gmail.com>
Subject: Re: [PATCH 12/12] perf tools: Try to build Documentation when installing
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 6:50 AM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> There's a portion in the "perf list" output refering to the exact
> specification of raw hardware events.
>
> Since this description is in the perf-list manpage, try to build and
> install the man pages, warning the user when that is not possible
> due to missing packages (xmlto and asciidoc).
>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Link: http://lkml.kernel.org/n/tip-ij71ysszkdvz3fy3wr331bke@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>


Thanks,
Namhyung
