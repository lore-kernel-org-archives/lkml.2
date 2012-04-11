Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2DKHMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:12:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55356 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2DKHMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:12:18 -0400
Date: Wed, 11 Apr 2012 00:12:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tom Lin <tom_lin@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
Message-ID: <20120411071212.GB6894@core.coreip.homeip.net>
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Tue, Apr 10, 2012 at 08:42:46PM +0800, Tom Lin wrote:
> This patch adds driver for Elan I2C touchpad. These protocol of HID-I2C was
> defined by Microsoft. The kernel driver would use the multi-touch protocol
> format B.
> 

If this device truly supports HID protocol shouldn't we define i2c-hid
transport, similar to usbhid?

Thanks.

-- 
Dmitry
