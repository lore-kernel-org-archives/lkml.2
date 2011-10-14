Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1JNGON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:14:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32897 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1JNGOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <1318557712.2027.1.camel@shrek.rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	<201110062045.48689.rjw@sisk.pl>
	<2409186928.1003010428@rexursive.com>
	<201110132326.02041.rjw@sisk.pl>
	<1318557712.2027.1.camel@shrek.rexursive.com>
Date: Fri, 14 Oct 2011 09:14:11 +0300
X-Google-Sender-Auth: uCFmfsHHqNronE990b5_j2Tmcic
Message-ID: <CAOJsxLF2Qo0UK8wCg1mt2Awiv7k=XPA9kHMy808f++FXibi4QA@mail.gmail.com>
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 5:01 AM, Bojan Smojver <bojan@rexursive.com> wrote:
> On Thu, 2011-10-13 at 23:26 +0200, Rafael J. Wysocki wrote:
>> If your system is 64-bit, then the patch below may help.
>
> Unfortunately, it didn't. Got a hang after several hibernate/thaw just
> the same, when KMS was enabled.

What debugging options do you have enabled? Rafael, is there some list
of suggested debugging options that should be enabled when debugging
hibernation issues?

Bojan, this is with Intel drivers, right? I'm CC'ing Keith which might
be able to give some clues how to debug KMS related hibernate/thaw
issues.
