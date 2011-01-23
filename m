Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab1AWQWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 11:22:20 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:48476 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1AWQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 11:22:20 -0500
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Dynamic debug: Add more flags
Date: Sun, 23 Jan 2011 17:22:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.8-scst; KDE/4.4.4; x86_64; ; )
Cc: Greg Banks <gnb@fmeh.org>, Jason Baron <jbaron@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
References: <201101231717.24175.bvanassche@acm.org>
In-Reply-To: <201101231717.24175.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101231722.12264.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 January 2011 17:17:24 Bart Van Assche wrote:
> Add flags that allow the user to specify via debugfs whether or not the
> module name, function name, line number and/or thread ID have to be
> included in the printed message.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Greg Banks <gnb@sgi.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>

Apparently I had used an outdated e-mail address, so cc-ing:

Cc: Greg Banks <gnb@fmeh.org>

Bart.
