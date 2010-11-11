Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0KKG40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:56:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63045 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0KKG4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:56:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=SEwhBGXac+QmEKqDTGMqS5vT1VzIuNzDi5Qqs+tdENQoGJAofMSWeCGvqiuF50vgtV
         H7tZ2hGfGtK5RsxQgBVuDjDQ1hp6lAbJj60FscO9lOK2QCRZNwQSF1LvirTmY+ev0z7m
         ghWl4BouxeZgYISauPvY3uPoV0H9CR/40+pXs=
MIME-Version: 1.0
Date: Thu, 11 Nov 2010 14:56:24 +0800
Message-ID: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
Subject: [Questions] How to run 'perf top' on ARM to profile kernel functions
 with modules loaded
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

'perf top' can't display any functions when modules are loaded on ARM.

But if all modules are unloaded, everything is OK and kernel functions can be
displayed.

So how can I make 'perf top' to profile kernel functions when modules are loaded
on ARM?

thanks,
-- 
Lei Ming
