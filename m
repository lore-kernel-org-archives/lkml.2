Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0LPJ4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:56:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0LPJ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:56:01 -0500
Date: Thu, 16 Dec 2010 10:55:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Nauber <richard.nauber@googlemail.com>,
        Richard Nauber <Richard.Nauber@gmail.com>
Subject: Re: [PATCH] hid: egalax: Add support for Samsung NB30 netbook
In-Reply-To: <1292493175-21630-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1012161055060.16569@pobox.suse.cz>
References: <1292493175-21630-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010, Henrik Rydberg wrote:

> From: Richard Nauber <richard.nauber@googlemail.com>
> 
> The Samsung NB30 touch has a DWAV dual-touch device. This patch adds
> the NB30 to the list of supported devices, and grabs it accordingly in
> hid-core.
> 
> [rydberg@euromail.se: rename and log message changes]
> Signed-off-by: Richard Nauber <Richard.Nauber@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Jiri,
> 
> do I have your ACK on this one?

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

I will happily apply the patch to my queue. Or are you planning to put it 
together with some larger bundle?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
