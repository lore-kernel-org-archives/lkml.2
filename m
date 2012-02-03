Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2BCI74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:59:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2BCI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:59:54 -0500
MIME-Version: 1.0
From: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Date: Fri, 3 Feb 2012 11:59:10 +0300
X-Google-Sender-Auth: r2Md_0PSvjA6QOCnyD7TdiY1WXo
Message-ID: <CAKa7sPRgROFY2RfeVW0G_1EWzWXakuWu50tGQ2QuzrvEimU3FQ@mail.gmail.com>
Subject: TDM bus support in Linux Kernel
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: Michail Kurachkin <michail.kurachkin@promwad.com>,
        Ivan Kuten <ivan.kuten@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are designing custom hardware board where processor is connected
with analog telephony
SLIC via TDM bus.
During investigation of Linux kernel we did not find any corresponding TDM code.
So decided to write a new TDM subsystem in drivers/tdm (like SPI).
The subsystem consists of tdm_core.c which implements TDM bus routines,
e.g. tdm_register_board_info(), tdm_add_device(),
tdm_controller_register() etc, and
someplatform_tdm.c which implements platform specific TDM contoller.

Any suggestion if we have chosen right direction and our approach
conforms Linux kernel architecture?
May be there were already some preliminary work for this?

-- 
Best regards,
Viktar Palstsiuk
