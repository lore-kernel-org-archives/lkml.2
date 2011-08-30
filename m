Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1H3PVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:21:16 -0400
Received: from ixia-3.edge2.lax012.pnap.net ([74.217.148.5]:6827 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755031Ab1H3PVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:21:15 -0400
Message-ID: <4E5D0008.5090504@ixiacom.com>
Date: Tue, 30 Aug 2011 08:21:44 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: <jslaby@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] coredump: escape / in hostname and comm
In-Reply-To: <1307457010-7241-2-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I would like to suggest that both '%e' and '%E' use current->group_leader->comm
instead of just current->comm.

Using plain current->comm gets strange effects when threads within a process
start naming themselves using PR_SET_NAME (or its pthread_setname_np() equivalent).

Earl

