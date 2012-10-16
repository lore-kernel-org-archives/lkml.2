Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2JPSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:09:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51599 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2JPSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:09:56 -0400
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 13:09:55 -0500
Message-ID: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
Subject: VDSO gettimeofday() x86_64 linux 3.2
From: wilson self <wself00@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed recently that my get time of day calls are quite a bit
slower than I would have expected; and it would see that a likely
cause is that they are not going via vdso, but rather a system call.

In older kernels there was kernel.vsyscall64 parameter to enable them,
but this seems to be gone in later kernel releases.  What config
option or parameter might I be missing that could cause gettimeofday()
to use the fallback methods?

Thanks
wilson
