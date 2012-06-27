Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2F0LG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:06:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52094 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2F0LFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:05:18 -0400
Message-Id: <20120627110116.201735815@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jun 2012 15:01:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [rfc 0/7] [rfc] procfs, fdinfo seqfile providers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here is a bit updated version of procfs fdinfo providers (I've ported
the series to 3.5-rc4 kernel). Please review if you have time.

The base idea remains the same -- provide additional information
specified for file type (fanotify/eventpoll) via /proc/pid/fdinfo/$fd
suitable to restore suct file.

	Cyrill
