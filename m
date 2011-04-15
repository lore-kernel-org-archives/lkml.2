Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1DOKBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:01:54 -0400
Received: from smtp.nokia.com ([147.243.1.48]:60126 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab1DOKBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:01:52 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] mm: make read-only accessors take const pointer parameters
Date: Fri, 15 Apr 2011 12:56:16 +0300
Message-Id: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sending this one its own as it either becomes an enabler for further
related patches, or if nacked, shuts the door on them. Better to test
the water before investing too much time on such things.

Whilst following a few static code analysis warnings, it became clear
that either the tool (which I believe is considered practically state of
the art) was very dumb when sniffing into called functions, or that a
simple const flag would either help it not make the incorrect paranoid
assumptions that it did, or help me dismiss the report as a false
positive more quickly.

Of course, this is core core code, and shouldn't be diddled with lightly,
but it's because it's core code that it's an enabler.

Awaiting the judgement of the Solomons,
Cheers,
Phil
