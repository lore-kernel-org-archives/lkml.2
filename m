Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0EaWrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:47:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35938 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab0EaWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=cBO0ItUU73s/705TaPsVBfkJsZVQ3ofMlClQm6JmFM1+ZYAmGP4YxWur6V/13Cmr0P
         a+MMOJZfbfs+Co07UU4TkdECk5sKkcL1Bxp8/Wi5T0sBBkB5VYQUUVMTVhS63WWNQdNS
         3DmejIKi8iNC+01zS96XjlqZOpA0PSgF0PVJI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 1 Jun 2010 00:47:17 +0200
Message-ID: <AANLkTimjEegQQxqllHI2jolnAlgg4eAQdsmENeNnwBlT@mail.gmail.com>
Subject: [Regression] [2.6.35-rc1][suspend to ram] BUG: using 
	smp_processor_id() in preemptible [00000000] code: cat/3634
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC cpufreq@vger.kernel.org ]

[1] directs you to a fix from cpufreq ML.
It worked fine here on my HP nc6400 notebook.

- Sedat -

[1] http://lkml.org/lkml/2010/5/31/77
