Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab2DSHMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:12:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44004 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2DSHMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:12:01 -0400
Date: Thu, 19 Apr 2012 10:11:04 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH] smb347_charger: Cleanup power supply registration code
 in probe
Message-ID: <20120419071104.GG18520@mwesterb-mobl.lan>
References: <1334310292-22289-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334310292-22289-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 03:14:52PM +0530, Ramakrishna Pallala wrote:
> This patch checks if the usb or mains charging is enabled by the
> platform before registering with the power supply class.

Can you describe why this change is needed? The current code always registers
all the power-supplies but if we haven't enabled for example USB charging,
then the online property for USB ps is set to 0.
