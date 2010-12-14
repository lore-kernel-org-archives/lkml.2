Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab0LNC1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 21:27:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56939 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759010Ab0LNC1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:27:00 -0500
Date: Tue, 14 Dec 2010 13:26:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the input tree with Linus' tree
Message-Id: <20101214132658.ce0f5bc6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
include/linux/input.h between commit
86b17f76f462db460d6d916e105a4c44cb353e36 ("Input: document struct
input_absinfo") from Linus' tree and commit
a528f721b7c0ba70433dbddf5947eea458c3e36a ("Input: document new trkid
field in struct input_dev") from the input tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/input.h
index 979d4bd,787aa7e..0000000
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@@ -1155,7 -1125,8 +1150,8 @@@ struct ff_effect 
   *	of tracked contacts
   * @mtsize: number of MT slots the device uses
   * @slot: MT slot currently being transmitted
+  * @trkid: stores MT tracking ID for the current contact
 - * @absinfo: array of &struct absinfo elements holding information
 + * @absinfo: array of &struct input_absinfo elements holding information
   *	about absolute axes (current value, min, max, flat, fuzz,
   *	resolution)
   * @key: reflects current state of device's keys/buttons
