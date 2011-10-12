Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1JLOlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:41:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1JLOlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <1317344993-24945-20-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-20-git-send-email-keithp@keithp.com>
Date: Wed, 12 Oct 2011 15:41:11 +0100
Message-ID: <CAPM=9twEUUYrLS2_kk-dpa7WzvYhkEGN+B_pqPxKEJZN8o9UKQ@mail.gmail.com>
Subject: Re: [PATCH 19/21] drm/i915: Asynchronous eDP panel power off
From: Dave Airlie <airlied@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using the same basic plan as the VDD force delayed power off, make
> turning the panel power off asynchronous.

NAK, tested on my 2540p, up to this patch in macbook-air branch stuff
worked, after this I just get black screen on resume.

Dave.
