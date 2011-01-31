Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1AaU1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:27:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51022 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1AaU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Dqrbyx8ouX2NNtX8BSQTNhqofxNaAh4ZYNvC7WPRknLcO5GPA35Ib9i2W4DbgJ6Eqp
         UG8n1QYplJsLeXSN51UQadA0dC3HD2Uwh70G+QGYYbRRJbLfsEMMUiBOOm7jS/HZ9ILF
         YYqJX7k8706Zg9MJszzETkD6xMiZgYMsnX1ug=
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 15:27:08 -0500
Message-ID: <AANLkTik4WQreo35jGLMQA16u+R-Ed036B3okrrx2nBGy@mail.gmail.com>
Subject: what is spinlock depth
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am reading spinlock code and looking at struct raw_spinlock. I found
struct lockdep_map as member.
which is defined as

struct lockdep_map {
       struct lock_class_key           *key;
       struct lock_class               *class_cache[NR_LOCKDEP_CACHING_CLASSES];
       const char                      *name;
#ifdef CONFIG_LOCK_STAT
       int                             cpu;
      unsigned long                   ip;
#endif
};

Can anyone help me explain, how this struct helps the spinlock. Why do
we need lockdepth.
Thanks for help in advance.
-- 
Regards,
Sri.
