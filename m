Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0IZKAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 06:00:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0IZKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 06:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=s/OMKElPzJCIaSGP8p4XhCV3BSLQhzNN/CGDkOUWKDKsGMhHMTgIFZEmNsNUNOtZdp
         0FxCl836chZXpVSCCTqLys+GfYehgDcOQ9fgxqpWvaTnV/bOAkiKOcHvx/yaBsNiNWZ3
         49RwzwgjmVE3h8lJJRpM3IsswPbLotyNJKikw=
References: <1285491587-32707-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1285491587-32707-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A36AFE1D-1D31-4B93-B569-830215F0FD14@gmail.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Cyril Chemparathy <cyril@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] touchscreen: tnetv107x: fix input_device leak
Date: Sun, 26 Sep 2010 03:00:18 -0700
To: Vasiliy Kulikov <segooon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 26, 2010, at 1:59 AM, Vasiliy Kulikov <segooon@gmail.com> wrote:

> tsc_probe() calls input_free_device() on error, but tsc_remove()
> doesn't.

NAK. It is forbidden to call input_free_device() after unregister.

Thanks. 

-- 
Dmitry

