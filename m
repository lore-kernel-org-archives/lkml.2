Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2IOBtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:49:06 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58576 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2IOBtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:49:04 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 18:49:01 -0700
Message-ID: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
Subject: Getting debugfs mountpoint?
From: Jacob Sowles <sowlesj@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an easy way to get the path to where debugfs is mounted? I
found a function called debugfs_find_mountpoint(), which is exactly
what I want, but it’s not exported, so I can’t use it. The only
exported debugfs functions that I could find are the ones that create,
remove, etc.

Jacob
