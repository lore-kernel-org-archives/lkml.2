Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1HIFIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 01:08:37 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:64122 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab1HIFIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 01:08:36 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=869cbtyjxWwA:10 a=1WJb1u9HV30A:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=RXeU8HELxcKCRHieo4sA:9 a=wPNLvfGTeEIA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
Message-ID: <4E40C0D1.4030505@systemfabricworks.com>
Date: Tue, 09 Aug 2011 00:08:33 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux@horizon.com,
        joakim.tjernlund@transmode.se, fzago@systemfabricworks.com,
        rpearson@systemfabricworks.com, akpm@linux-foundation.org
Subject: [patch v3 0/7] crc32: add slicing-by-8 algorithm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a new algorithm slicing-by-8 to the
existing version of crc32.c and cleans up some minor warnings
from sparse. It also adds a functional self test that can be
used to both test the correctness and performance of the
crc32 algorithm on different architectures.

The main change from the previous version of this patch set
is to break up the patch into several smaller hunks.
