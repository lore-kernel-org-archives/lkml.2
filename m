Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0JTN2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:28:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0JTN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:28:03 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=52qKNi8qOWAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=qa50-PXr8-xnKRVCZDMA:9 a=xohALUO0sy-5diBBHE75nloM1J4A:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace-cmd: Search $TRACE_CMD_PLUGIN_DIR for plugins.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
In-Reply-To: <1285718416-1470-1-git-send-email-dhsharp@google.com>
References: <1285718416-1470-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Oct 2010 09:28:02 -0400
Message-ID: <1287581282.16971.553.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 17:00 -0700, David Sharp wrote:
> Allows dynamic specification of the plugin directory so that plugins can be
> used when the install prefix cannot be predicted, such as when using a
> pre-compiled version of trace-cmd with Autotest.
> 
> Signed-off-by: David Sharp <dhsharp@google.com>

Sorry for the late response, but... Applied.

Thanks!

-- Steve


