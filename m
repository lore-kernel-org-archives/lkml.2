Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0EJE4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:56:20 -0400
Received: from mail.perches.com ([173.55.12.10]:2111 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0EJE4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:56:07 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Florian Mickler <florian@mickler.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scripts/get_maintainer.pl: trivial improvements
Date: Sun,  9 May 2010 21:56:01 -0700
Message-Id: <cover.1273466698.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <1273396544-4189-1-git-send-email-florian@mickler.org>
References: <1273396544-4189-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A desire exists to reduce the number of people that are listed by
get_maintainers that may not actually be interested in receiving
patches.  Non-standard signature types may not indicate a desire to
receive patches.  Add the ability to only use selected signature types.

Joe Perches (2):
  scripts/get_maintainer.pl: optionally ignore non-maintainer signatures
  scripts/get_maintainer.pl: add .get_maintainer.conf default options file

 scripts/get_maintainer.pl |   66 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 56 insertions(+), 10 deletions(-)

