Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2ALBhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:37:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46906 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2ALBhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:37:36 -0500
MIME-Version: 1.0
In-Reply-To: <4F0E38E6.4070606@lge.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	<1326220106-5765-10-git-send-email-tj@kernel.org>
	<20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F0D291A.8030205@lge.com>
	<20120111170635.GE26832@google.com>
	<4F0E31D9.3080306@lge.com>
	<CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com>
	<4F0E38E6.4070606@lge.com>
Date: Wed, 11 Jan 2012 17:37:35 -0800
X-Google-Sender-Auth: AYYGpZfeFiCNjE0_tLyZ4GHD57M
Message-ID: <CAOS58YNSn079KusXuEYf7agyWgMyaZahp7+4rWRFQz_G3k8CjQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 11, 2012 at 5:35 PM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Why do we need to trigger the TP for existing ones as we keep each entry at
> its creation? Maybe I'm missing something?

If a userland program starts to watch the TP after some intents are
created, how is it gonna find out the existing ones?

-- 
tejun
