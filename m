Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2CEKMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:12:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab2CEKMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:12:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eldmannen@gmail.com designates 10.42.156.7 as permitted sender) smtp.mail=eldmannen@gmail.com; dkim=pass header.i=eldmannen@gmail.com
MIME-Version: 1.0
Date: Mon, 5 Mar 2012 11:12:35 +0100
Message-ID: <CAJgfmqXnCsgei_XBhb-DH4VKn=cGbP5hX4f8G9Nf3_chE+VReQ@mail.gmail.com>
Subject: Does /dev/random use RdRand?
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Ivy Bridge processors will feature the RdRand instruction for the
hardware random number generator.
https://en.wikipedia.org/wiki/RdRand

Does /dev/random use RdRand?
Perhaps it should.

Could use CPU built-in hardware RNG to seed the entropy pool.
