Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab2IUVmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:42:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55905 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2IUVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:42:06 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 21 Sep 2012 18:41:44 -0300
Message-ID: <CAMOw1v7ihLgrrtgak2s9hDDsUrSnD7wO8FJTrZvsrJzarH6ZRg@mail.gmail.com>
Subject: Drop support to compressed modules?
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-modules <linux-modules@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Reisner <d@falconindy.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I'd like to ask people the following question: why are you using
compressed modules? Is it only for the disk space or is there any
performance related reason?

While fixing a bug in kmod related to using compressed modules (that
already existed in module-init-tools) we stopped to think about these
questions. Dave made a couple of benchmarks and performance wise it's
better to use uncompressed modules than modules with gz or xz
compression. However the benchmark was done in only 1 computer. I do
expect people with slow storage to have different numbers though. Does
anyone have these numbers?


About the bug, I think it's fixed in
http://www.spinics.net/lists/linux-modules/msg00846.html. Need to test
a bit more before rolling out a new release.


Regards,
Lucas De Marchi
