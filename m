Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2HSQIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 12:08:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38787 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2HSQIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 12:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <1345391202-71865-1-git-send-email-dsahern@gmail.com>
References: <1345391202-71865-1-git-send-email-dsahern@gmail.com>
Date: Sun, 19 Aug 2012 19:08:44 +0300
X-Google-Sender-Auth: VZwJFRVT7xkgwtTCRBMjctlqykE
Message-ID: <CAOJsxLHcc-uKx6zy2GE6pt6gCJ-dRxwEayC_LVRF_3QNQPR0eg@mail.gmail.com>
Subject: Re: [PATCH] perf: silence GTK2 probing errors
From: Pekka Enberg <penberg@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 6:46 PM, David Ahern <dsahern@gmail.com> wrote:
> If GTK2 development packages are not installed, make is rather noisy:

[snip]

> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
