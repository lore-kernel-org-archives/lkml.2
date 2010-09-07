Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0IGRiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:38:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62402 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab0IGRiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=tuQpZHeXyPnLuJMhUdGfahKpeCwnAgKwDEncfJFmxp7JCNttA88qkFNhlZfb/P1hZ+
         U9KVo0Ozrrck5VonItUHYbZ2FlL/Eh1g4C+eXrXKsdqSAkci58HGeQqRWKx4fSicm4X/
         Rc36T2qVaDEISZIH/tf5D2Jqq3V5resigo7t8=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35.4: sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow
Date: Tue, 7 Sep 2010 18:34:27 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009071834.27953.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sudo rmmod ahci @ 2.6.35.4 succeeds: filesystem access errors follow.

Now what I'm surprised is not the filesystem errors but me being allowed to 
remove the module without using the '-f' option.

Do note, lsmod |grep ahci reports something like [this is adapted from a 
2.6.32 kernel]:

ahci                   32200  0

so it isn't at all surprising I'm being allowed to remove a seemingly unused 
module. So....
a) is this supposed to happen?
b) do you need any more info?

P.S.: CC'ing me will probably ensure I'll reply faster but not explicitly 
needed since I'm subscribed.
-- 
Pedro
