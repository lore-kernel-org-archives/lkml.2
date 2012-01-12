Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2ALBoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:44:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60753 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2ALBoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <4F0E3A53.8050208@lge.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	<1326220106-5765-10-git-send-email-tj@kernel.org>
	<20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F0D291A.8030205@lge.com>
	<20120111170635.GE26832@google.com>
	<4F0E31D9.3080306@lge.com>
	<CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com>
	<4F0E38E6.4070606@lge.com>
	<CAOS58YNSn079KusXuEYf7agyWgMyaZahp7+4rWRFQz_G3k8CjQ@mail.gmail.com>
	<4F0E3A53.8050208@lge.com>
Date: Wed, 11 Jan 2012 17:44:06 -0800
X-Google-Sender-Auth: cWr2dBSe9DcKGe0Epfhneoo6tEE
Message-ID: <CAOS58YPi5_jsCTqBpNxDyy+cDcr-8WvqUe9r1qBbjdCOT22Q3w@mail.gmail.com>
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

On Wed, Jan 11, 2012 at 5:41 PM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> OK, but that can be controlled from userspace, I guess? Do we have to care
> about that?

Otherwise, it's gonna be a pretty silly interface. If you want to
watch the TP, you have to restart the whole thing which also implies
intent number would change. And there still is the problem of losing
new intent events due to overflow. It just isn't the right interface
for the task.

-- 
tejun
