Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2HFObM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:31:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49764 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab2HFObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:31:11 -0400
MIME-Version: 1.0
X-Originating-IP: [121.7.238.199]
Date: Mon, 6 Aug 2012 22:31:09 +0800
Message-ID: <CAMVG2su47PegSW75aGomPP_6ot86suks9o29MiFEvneY4mTgyQ@mail.gmail.com>
Subject: rts5139 polling overhead...
From: Daniel J Blueman <daniel@quora.org>
To: edwin_rong <edwin_rong@realsil.com.cn>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, wei_wang@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Edwin,

The Realsil/Realtek rts5139 card reader driver polls it's hardware at
20Hz and has racked up 25 minutes of processor time over a few days on
this Sandy Bridge media centre box, without any cards inserted. This
is more than the sum of all the other processes (including X):

$ ps -ef | grep rts5139
root       691     2  0 Aug03 ?        00:00:36 [rts5139-control]
root       693     2  0 Aug03 ?        00:25:36 [rts5139-polling]

The kernel is stock 3.5.0 without debug; would it help if I log a bug
report or eg collect further detail?

Thanks,
  Daniel
-- 
Daniel J Blueman
