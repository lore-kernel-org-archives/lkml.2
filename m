Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1IGQdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:19 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:47140 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1IGQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:14 -0400
MIME-Version: 1.0
Date: Wed, 7 Sep 2011 23:33:13 +0700
Message-ID: <CA+i8gK+H4Y=+ZMr9QHh-1mn0wEdhDzf4iSqUgD322UhyXoruCg@mail.gmail.com>
Subject: [GIT BISECT] 2c1756b12edc19fdd75c833699cb752e1bbb641e - Display
 corruption after blank screen state
From: Emmanuel Benisty <benisty.e@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following commit causes display corruption once the machine goes
out from default X server power saving blank screen state. This is
with an i3 330m.

commit 2c1756b12edc19fdd75c833699cb752e1bbb641e
Merge: cf96e46 d74362c
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Jul 28 16:30:41 2011 -0700

    Merge branch 'drm-intel-fixes' into drm-intel-next

Thanks.
