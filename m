Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0DSVCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:02:54 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:64836 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0DSVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:02:53 -0400
X-Greylist: delayed 885 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 17:02:52 EDT
MIME-Version: 1.0
Date: Tue, 20 Apr 2010 07:02:52 +1000
Message-ID: <m2n836a6dcf1004191402gbd659247i215b627acb2b1e0e@mail.gmail.com>
Subject: Problems with gobi loader - qualcomm 3g card on hp min 5101
From: Alexander Samad <alex@samad.com.au>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry if this is the 3rd post, I haven't seen it hit the archives and
i wasn't sure if it actually made it through  - originally sent as
html (gmail).

I have a HP Mini with their wwan module (Qualcomm 3g card), it
attaches via the usb interface. It was working (not sure exactly but
about 2 months ago) and when I went to use it recently it didnot work
any more - the gobi loader get stucks uploading firmware to the card
:(

I have had the motherboad and the card replaced.... I have removed the
udev rule which calls the loader removed and tried it manually. From
reading on other forums it seems like adding a delay to firmware
upload can help.

I have noticed with strace that some of the firmware get uploaded some
of the time and then it just hangs :(

I am not sure what or how to debug this, so I have come to the list.
running debian i386 2.6.32-4

Alex
