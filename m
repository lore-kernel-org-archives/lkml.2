Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2I0WwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:52:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44461 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2I0WwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:52:07 -0400
MIME-Version: 1.0
Date: Thu, 27 Sep 2012 18:52:07 -0400
Message-ID: <CAEs_ynt023pu4hJfrusxhXWHdwgU9aY1h55pka1OO-tKGxD8Fg@mail.gmail.com>
Subject: Rregressions in Power Management and others
From: Nigel Cooper <coopernigel5@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many hardware devices, new power management features introduced
into the Linux kernel cause problems. from not being able to boot to
the video output not refreshing when the system is idle. It is my
proposition to drop newer power features introduced in the past year
or so.

In addition, USB is an increasingly obsolete standard and I recommend
it be disabled in favor of Bluetooth, which has shown its  potential
to be a large part of our future even since the early days when it
only connected headsets to telephones.
