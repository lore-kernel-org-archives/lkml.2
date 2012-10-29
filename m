Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494Ab2J2Syz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:54:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45309 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab2J2Syx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <508ECC63.3020302@mvista.com>
References: <1351530030-7080-1-git-send-email-jwerner@chromium.org>
	<508ECC63.3020302@mvista.com>
Date: Mon, 29 Oct 2012 11:54:52 -0700
X-Google-Sender-Auth: JGhD4k6cT5SDqE5EHGO22xmU19E
Message-ID: <CAODwPW9fTYre=PnwEt5q7WVu7gVDDd05zYxHmJ8d3bJRm_-2XA@mail.gmail.com>
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying
 half-built segment rings
From: Julius Werner <jwerner@chromium.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    I have noticed that the patch description has DOS line endings as well.

Sorry about those, Gmail adds them automatically. According to RFC
2046 (section 4.1.1), text/plain content must use CRLFs to encode line
breaks, so I guess this is the right thing. Your MUA should be
responsible for converting them to native endings upon retrieval (and
if it doesn't, git-am will).
