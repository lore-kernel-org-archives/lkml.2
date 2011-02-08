Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1BHMiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:38:16 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:15344 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1BHMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:38:15 -0500
X-RZG-AUTH: :O2kGeEG7b/pS1E64W3aniLTNDUcEh+JwjGMyQkjVygg3aAH02IubSkmAm8qJPah6OYR9kg==
X-RZG-CLASS-ID: mo00
Subject: mmap, the language go, problems with the linux kernel
From: martin capitanio <m@capitanio.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 13:37:58 +0100
Message-ID: <1297168678.2190.21.camel@marvin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There popped up a serious problem by implementing a fast memory
management for the language go. Maybe some experienced kernel hacker
could join the discussion and help to find the best linux solution for
the "mmap fiasco" problem.

https://groups.google.com/forum/#!msg/golang-dev/EpUlHQXWykg/LN2o9fV6R3wJ

Thanks (in behave of all linux go users:),
Martin

