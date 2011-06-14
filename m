Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1FNL5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:57:44 -0400
Received: from science.horizon.com ([71.41.210.146]:11986 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756083Ab1FNL5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:57:41 -0400
Date: 14 Jun 2011 07:57:40 -0400
Message-ID: <20110614115740.32527.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc1 stuck process in munmap()
Cc: linux-mm@kvack.org, linux@horizon.com
In-Reply-To: <20110614114854.31801.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update: I kiled vlc and a few other things in preparation for rebooting,
and firefox un-wedged itself.  Very confusing.

3.0-rc3 has compiled and I'm going to reboot anyway, but FWIW, it wasn't
quite as hard a lockup as I thought.
