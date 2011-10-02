Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1JBKl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 06:41:58 -0400
Received: from lucidpixels.com ([72.73.18.11]:56830 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1JBKlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 06:41:55 -0400
Date: Sun, 2 Oct 2011 06:41:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 3.1-rc8 still references 2.6.42 when ioctls will be removed
Message-ID: <alpine.DEB.2.02.1110020640390.3972@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI--

[   48.519528] uvcvideo: Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} ioctls will be removed in 2.6.42.

$ grep 2.6.42 -r /usr/src/linux/*

/usr/src/linux/drivers/media/video/uvc/uvc_v4l2.c:                 "ioctls will be removed in 2.6.42.\n");

Justin.

