Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0DJInU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:43:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60039 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0DJInQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hp0yTkK2bgdQUhVpb9d3GBi8fU3BZC6xU9O3HKDwCxv7juHhH9XusREqiWIisPrDND
         LjzaBx5bEv1athkHYw7PW7UB7bssJGahx9tbPmwO+4VUavW+Ze1KxjtCfNtvnpEGlaIh
         p6Rce3uzyJwKL4WHrofw+5rZIDuJwnz7HK2e8=
MIME-Version: 1.0
Date: Sat, 10 Apr 2010 04:43:13 -0400
Message-ID: <k2o49f90a801004100143q8a546d5dnf85d3d1b924b406e@mail.gmail.com>
Subject: Probing System calls
From: Siddhartha Chhabra <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to probe the read and write system calls using jprobe and
kretprobes. In the first place, sys_read was not exported, so I have
exported the symbol and I am successfully able to register the probes.
Next I have a small piece of code that just invokes the read system
call. Now after I insert the module with the probes and run the
program with the read system call, it does not show the system call
called with the size parameter that I pass. For e.g. I call ./read
1234, the debug messages have a lot of prints but for sizes like 1,
4096, but never 1234. Since the debug message are getting printed, it
tells me that the probe has been registered successfully, however, I
was wondering why it never gives a message with the size i passed. Is
there something I am missing on probing the system call, or is there a
fundamental limitation on probing system calls...

I appreciate any comments/suggestion...

Thanks
