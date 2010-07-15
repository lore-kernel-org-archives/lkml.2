Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0GOCsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:48:36 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46653 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0GOCsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=H3Q2k613Vqe3kYmsi3qkDDas+y+mZ4VrY5nAnhopmJO2DXIawyL2j9/6uUoRUTamfR
         bTzFBjIA66NrAmjJSmBIXUdKbGAeCtYqXsaa/MyGjx6LLJZuyREJfQtR7Nm2hyHX9vmg
         ooNhudJfQNJickNcxsLro2GMb1mOtZLEFa5TA=
Subject: [PATCH 0/12] sound/alsa/soc/codec: fix memory leak and resource
	relaim in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Thu, 15 Jul 2010 10:49:07 +0800
Message-Id: <1279162147.29294.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This serial of patches fixes memory leak and resource relaim in error path

[PATCH 1/12] ad1836: fix a memory leak if another ad1836 is registered
[PATCH 2/12] ak4642: fix a memory leak if failed to initialise AK4642
[PATCH 3/12] da7210: fix a memory leak if failed to initialise da7210 audio codec
[PATCH 4/12] wm8523: fix resource reclaim in wm8523_register error path
[PATCH 5/12] wm8711: fix a memory leak if another WM8711 is registered
[PATCH 6/12] wm8904: fix resource reclaim in wm8904_register error path
[PATCH 7/12] wm8940: fix resource reclaim in wm8940_register error path
[PATCH 8/12] wm8955: fix resource reclaim in wm8955_register error path
[PATCH 9/12] wm8961: fix resource reclaim in wm8961_register error path
[PATCH 10/12] wm8974: fix a memory leak if another WM8974 is registered
[PATCH 11/12] wm8978: fix a memory leak if another WM8978 is registered
[PATCH 12/12] wm9081: fix resource reclaim in wm9081_register error path

Regards,
Axel


