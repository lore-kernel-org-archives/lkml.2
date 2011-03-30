Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1C3MVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:21:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52348 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1C3MV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:21:29 -0400
MIME-Version: 1.0
X-Originating-IP: [203.101.61.7]
Date: Wed, 30 Mar 2011 17:51:27 +0530
Message-ID: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
Subject: locks inside receive_buf
From: Pavan Savoy <pavan_savoy@sify.com>
To: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does holding a lock make any sense inside the line discipline's
ops->receive_buf?
I see the locks being held and released - during some calls like
flush_to_ldisc, which end up calling receive_buf....


and yes, I would like to have a lock because, there are other
functions in my ldisc driver executed in process context ...
Is there some hints as to what should be the do's and don'ts inside
the ldisc ops functions ? (say tty_wakeup ...)

regards,
Pavan
