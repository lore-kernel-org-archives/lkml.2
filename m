Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0IVLEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:04:45 -0400
Received: from xenon13.um.es ([155.54.212.167]:51969 "EHLO xenon13.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0IVLEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:04:44 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 07:04:44 EDT
Subject: CFQ I/O scheduler better than AS?
From: Juan PC <piernas@ditec.um.es>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 22 Sep 2010 12:55:08 +0200
Message-Id: <1285152908.10774.306.camel@albahaca.inf.um.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I am sure that, for most people, the clear answer is "yes" (after all,
CFQ is the default I/O scheduler in Linux), but we are having serious
difficulties to find a benchmark which shows that CFQ is undoubtedly
better than AS.

We use several benchmarks and, in all of them, either AS is clearly
better than CFQ, or their performances are very similar.

Therefore, the question is, does such a benchmark exist?

Regards,

	Juan


