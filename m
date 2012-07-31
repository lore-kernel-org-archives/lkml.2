Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2GaJvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:51:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55055 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2GaJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:51:35 -0400
MIME-Version: 1.0
From: Jeroen Ooms <jeroen.ooms@stat.ucla.edu>
Date: Tue, 31 Jul 2012 11:51:14 +0200
X-Google-Sender-Auth: 5Thkd7Eu6h-MvD5LmTmLYl6W9TA
Message-ID: <CABFfbXu_SB7K+jdmp7w3=5KGvQGOnvVGXK1XK7K-ubOJg+k3SQ@mail.gmail.com>
Subject: What is the use of RLIMIT_NICE ?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using prlimit in Ubuntu to do some resource restrictions in my
sandbox which has been very helpful. However, I am not quite sure what
to do with RLIMIT_NICE. The docs say:

RLIMIT_NICE: Specifies a ceiling to which the process's nice value can
be raised using setpriority(2) or nice(2).

However, according to getpriority(2), a process can raise it's nice
value only if owned by a superuser in the first place. But if this is
the case, the RLIMIT_NICE value is not going to add too any
functionality because a privileged user can arbitrarily lower or
higher RLIMIT values anyway.

So I don't understand how to use or interpret RLIMIT_NICE. For
non-privileged users the entire thing seems useless because they
cannot raise priority in the first place, and it makes no sense to set
it below the current priority. However for superusers it doesn't
really add anything either because thenice, and RLIMIT_NICE soft- and
hard limits can arbitrarily be raised.

So what is the idea behind RLIMIT_NICE ?

Thank you very much,

Jeroen


ps: please cc in reply.
