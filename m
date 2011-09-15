Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1IOJg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:36:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab1IOJg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:36:27 -0400
Date: Thu, 15 Sep 2011 11:36:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtitmuss@logitech.com, ogay@logitech.com, jzanone@logitech.com
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying
 receivers
In-Reply-To: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com>
Message-ID: <alpine.LNX.2.00.1109151136040.13109@pobox.suse.cz>
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Nestor Lopez Casado wrote:

> From: Nestor Lopez Casado <nlopezcasad@logitech.com>
> 
> With this driver, all the devices paired to a single Unifying
> receiver are exposed to user processes in separated /input/dev
> nodes.

Applied. Thanks everybody.

-- 
Jiri Kosina
SUSE Labs
