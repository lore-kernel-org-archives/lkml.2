Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2DXB7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:59:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52927 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2DXB7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:59:20 -0400
Date: Mon, 23 Apr 2012 18:59:16 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: ldewangan@nvidia.com, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: mfd/tps65910: section mismatch for tps65910_sleepinit()
Message-ID: <20120424015916.GC2321@cantor.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: ldewangan@nvidia.com, sameo@linux.intel.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking into another problem I noticed a section mismatch with
tps65910_i2c_probe() calling tps65910_sleepinit() which is annotated
__init. Should tps65910_i2c_probe() be annotated __init as well?

