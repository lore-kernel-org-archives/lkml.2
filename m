Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab2CLPq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:46:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab2CLPqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:46:24 -0400
Date: Mon, 12 Mar 2012 16:46:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
In-Reply-To: <1331565459-1892-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Simon Wood wrote:

> This patch adds support for the G27 LEDs. The LEDs are controlled
> by a 5bit value (0-31) where bit0 is the right most LED, the LEDs
> are mirrored to the left.
> 
> Arrangement on wheel is:
>    G G Y Y R R(bit4) Y Y G G(bit0)

Simon,

is there a usespace application operating on top of this?

Also, it'd be necessary to document this properly in Documentation/ABI.

-- 
Jiri Kosina
SUSE Labs
