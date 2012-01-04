Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2ADEgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 23:36:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48602 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab2ADEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 23:36:49 -0500
Date: Wed, 4 Jan 2012 08:36:44 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@nsc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/3] power: Add LP8727 charger driver
Message-ID: <20120104043644.GB26010@oksana.dev.rtsoft.ru>
References: <B567DBAB974C0544994013492B949F8E380F619DDF@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E380F619DDF@EXMAIL03.scwf.nsc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 01:54:34AM -0700, Kim, Milo wrote:
> 
> Signed-off-by: Woogyom Kim <milo.kim@nsc.com>
> 
> From 83130c4498cff1b40b68babfba405cacbb27e291 Mon Sep 17 00:00:00 2001
> From: Woogyom Kim <milo.kim@nsc.com>
> Date: Wed, 7 Sep 2011 17:34:46 +0900
> Subject: [PATCH] LP8727 is the battery charger with Micro/Mini USB interface.
>  This IC includes below functions
>   - I2c interface for accessing user registers
>   - Single input Li-Ion battery charger
>   - Charger input ID detection from Micro/Mini USB
>   - multiplexing switches on USB, UART

All three applied. (Though, I merged them into one patch.)

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
