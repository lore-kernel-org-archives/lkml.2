Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2DSTJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:09:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46577 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063Ab2DSTJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:09:18 -0400
Date: Thu, 19 Apr 2012 22:08:20 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v2] smb347_charger: Cleanup power supply registration
 code in probe
Message-ID: <20120419190820.GB877@mwesterb-mobl.lan>
References: <1334809818-5958-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334809818-5958-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:00:18AM +0530, Ramakrishna Pallala wrote:
> This patch checks if the usb or mains charging is enabled by the
> platform before registering with the power supply class.

I still don't like the idea of having the power-supplies registered
conditionally. Now you need to check in every place whether the corresponding
power-supply is registered or not which makes the code uglier and more prone
to errors.
