Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2AMSy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:54:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52404 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2AMSy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:54:28 -0500
MIME-Version: 1.0
In-Reply-To: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
References: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
Date: Fri, 13 Jan 2012 18:54:27 +0000
Message-ID: <CAJAFBLCP=4_nuExevTsyuVOBw4BH0h7Gk=qQqaOFxohZafwRbA@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests: New very basic kernel selftests directory
From: Fubo Chen <fubo.chen@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 2, 2011 at 3:41 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Bring a new kernel selftests directory in tools/testing/selftests.

Interesting ... but why to invent a test framework from scratch while
there already exists stuff like googletest or TAP::Harness ?

Fubo.
