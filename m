Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2F0NWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:22:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49601 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2F0NWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:22:10 -0400
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 21:22:09 +0800
Message-ID: <CAJRGBZw_my_=Z+Jyb2UBYwW48BpCGYdcuD5mu7erHsX8NSKbDg@mail.gmail.com>
Subject: CPU isolation question again
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I noticed some discussion about CPU isolation which points me to the
patch set (https://lkml.org/lkml/2011/8/15/245). I'm currently
preparing a RFC-patch-set to automatically pick up a few suitable CPUs
to isolate then kick them out of service for a while. We need to
balance between  thermal & power management And overall system
performance during this operation as much as possible. So
software-cpu-online-offline interface could not be a good option to
me. But to make sure I'm not blindly running on a dead-end path, I'd
check with experts here to ensure it makes some sense to isolate CPUs
to this level, and the idea also makes some sense, and the most
important is it's not implemented yet.

Thanks!!
