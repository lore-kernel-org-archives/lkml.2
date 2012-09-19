Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2ISQCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:02:21 -0400
Received: from exchange.glccom.com ([209.152.99.146]:12118 "EHLO
	exchange.glccom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab2ISQCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:02:19 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 12:02:19 EDT
From: Paul Albrecht <palbrecht@glccom.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: timerfd_create/read expirations
Message-ID: <CBCAB8C0-690E-422A-9F9D-1C38BA97AB02@glccom.com>
Date: Wed, 19 Sep 2012 10:56:43 -0500
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
X-Mailer: Apple Mail (2.1486)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm developing/maintaining an application that uses timer expirations via a file descriptor for timing and I have a question about timer expirations. My application hiccups from time to time--I get a lot of timer expirations--so I'm wondering what I can do to determine the cause or better to  limit the number of expirations. Any ideas?

Please cc me if you respond to this message as I'm not usually subscribed to the list.

Paul Albrecht