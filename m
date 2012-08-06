Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2HFCCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:02:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47227 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2HFCCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:02:22 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 02:02:21 +0000
Message-ID: <CAGh4K3+8etOJvS6PCuJJjtj978F5rtpck_Y34Owqx+yhbg3LhQ@mail.gmail.com>
Subject: [PATCH]: Mac80211
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source file needed a change  that was told in the description to
know that the #include needed to be fixed, and the function changed
another value to 0 (yes) in the description (that said FIXME.)
Thanks,
-- 
Christopher
