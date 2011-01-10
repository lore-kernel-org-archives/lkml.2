Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1AJWtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:49:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64200 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1AJWtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:49:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=h6slJI3caHAeYRwuGnGxYQ/uLBeqD4MpaCVCwLWitTDT2VTd41dg8PtB+evQuMqSEH
         fQDknbrQqM3aiHu8dQiMULgGjUa9b1z8P2vBxA7K5xrxIFvifsxk5Dbv0NDz+fIh0C0G
         VK0MIzZ9AM/moCuO5jP6c/c7ALKOcvwyKmXVs=
MIME-Version: 1.0
In-Reply-To: <AANLkTimK5bBgfnRKQ8AR42aCdjVh0puLTB4g6L4oqBP_@mail.gmail.com>
References: <AANLkTimK5bBgfnRKQ8AR42aCdjVh0puLTB4g6L4oqBP_@mail.gmail.com>
From: Valery Khamenya <khamenya@gmail.com>
Date: Mon, 10 Jan 2011 23:48:55 +0100
Message-ID: <AANLkTimu_F=+AetL1NDdbVGav0Fsd8xnAZ6whsBEPVXZ@mail.gmail.com>
Subject: kernel support for Single System Image (SSI) clustering
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi gurus,

QUESTIONS:

  Q1. is it possible to make Linux kernels more friendly to SSI-clustering ?

  Q2. is there any support for SSI-clustering planned for next kernels?


DETAILS:

During 2005-2006 I've been using OpenSSI cluster based on patched
Linux kernel and was very, very happy. With almost no efforts I was
able to compute things overnight using OpenSSI that otherwise
would take days.

Five years ago I've been expecting that one day Linux dev community
will adopt the most interesting parts from OpenSSI and/or Kerrighed.
(There was and is also an alternative project -- Kerrighed, which is
comparably good)

It doesn't look that things have changed during last 5 years.

So, those heroes from OpenSSI and Kerrighed continue to patch
kernels. Their patched kernels come out always a-bit-too-old for
an average users. I talk to well-experienced programmers, sysadmins,
data analysts, molecular biologists, etc and many of them still don't
even know what SSI is! -- yes, even those, who used to be good
Python programmers. Some say "cool", but then they hear things
like "modified Linux kernel" and become less optimistic.

The barrier is still way too high.

To my poor understanding the future of SSI was and is very
dependent on how the Linux kernel is friendly to SSI and is
dependent on how do the kernel developers value the SSI.
I am just a usual data-mining analyst sitting on top of Ubuntu.
And I would be very thankful if you, gurus, could change things
and bring SSI-clustering closer to current modern Linux distributions.

Comments are very welcome!

best regards
--
Valery A.Khamenya
