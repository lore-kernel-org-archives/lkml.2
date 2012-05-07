Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2EGIBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:01:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab2EGIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:01:16 -0400
MIME-Version: 1.0
Date: Mon, 7 May 2012 04:01:14 -0400
Message-ID: <CAMgWh9sgAfoqtTh79F43dLKz21_eW-M9o3NYLt+NtSjXg9M3nQ@mail.gmail.com>
Subject: A thought following the stupid debate on stable versions
From: David Feuer <david.feuer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras was being very silly in criticizing a development
cycle that works well, but I just realized that what he and others
would likely actually want (which may already exist) is a list of
kernel versions with two properties:

1. They don't have showstopper-class bugs affecting one or more
popular architectures, and
2. Their more important bugs are fairly well characterized.

For each kernel on this list there would be (is?) a fairly exhaustive
list of important bugs (for some value of important, but not including
performance regressions unless they are very severe) that have come to
light since the kernel was released.  These kernels would be (are?)
the ones most likely to end up being used by distros, and also by
users who roll their own but want to avoid problems.  I have no idea
whether such a list already exists, and I have no idea what it would
take to create/maintain such a list if there isn't one currently.

David Feuer
