Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1K2JXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:23:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54788 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2JXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:23:48 -0500
Date: Tue, 29 Nov 2011 01:23:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: ad7879-i2c - remove redundant MODULE_ALIAS
Message-ID: <20111129092343.GC21758@core.coreip.homeip.net>
References: <1322532472.3213.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322532472.3213.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:07:52AM +0800, Axel Lin wrote:
> MODULE_DEVICE_TABLE will setup the module alias for us, thus adding
> MODULE_ALIAS for an entry already in MODULE_DEVICE_TABLE is redundant.
> 

Applied this and samsung-keypad one. Thanks Axel.

-- 
Dmitry
