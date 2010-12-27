Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0L0A22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 19:28:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab0L0A21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:28:27 -0500
Date: Sun, 26 Dec 2010 17:28:40 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
Message-ID: <20101226172840.75d5c4b1@lembas.zaitcev.lan>
In-Reply-To: <874477.56229.qm@web65712.mail.ac4.yahoo.com>
References: <874477.56229.qm@web65712.mail.ac4.yahoo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Dec 2010 14:14:44 -0800 (PST)
Tsozik <tsozik@yahoo.com> wrote:

> My apology, reading Greg's post I realized that 2.6.35 (distributed with
> Fedora 14) is indeed outdated. I just checked out 2.6.37-rc7 tree and saw
> references to get_icount function. I will definetely address your concern,

Thanks. I figured there was a reason for us to do this (if nothing else,
to get rid of casts with __user). So, you might as well align the code
with the current practice.

Please try to be more careful with spaces and tabs. I didn't want to
focus on such small things right from beginning, but they are considered
important.

Yours,
-- Pete
