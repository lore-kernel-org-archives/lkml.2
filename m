Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2E3GUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:20:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47406 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab2E3GT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120530013118.GA11319@infradead.org>
References: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
	<20120530013118.GA11319@infradead.org>
Date: Wed, 30 May 2012 09:19:56 +0300
X-Google-Sender-Auth: VwXHDmD1BWG3W1lFngDIN43ju24
Message-ID: <CAOJsxLHtyX4MAxAAiY_zSXXhXqgkC86Fy-_hYX4yBgVjALzsNg@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf ui: Add basic error handling for GTK2 front-end (v3)
From: Pekka Enberg <penberg@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 4:31 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Tue, May 29, 2012 at 01:22:55PM +0900, Namhyung Kim escreveu:
>> Hi,
>>
>> This patchset implements ui__warning/error() functions for GTK2.
>> Patch 1 is a resend (which forgot to cc LKML) and independent of
>> this series. Patch 2 converts invocations of ui__warning followed
>> by exit (or similar effect) into ui__error.
>
> Pekka, all well with you? Acked-by?

Looks good to me!

Acked-by: Pekka Enberg <penberg@kernel.org>
