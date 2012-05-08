Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2EHGbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 02:31:51 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35111 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2EHGbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 02:31:49 -0400
Message-ID: <4FA8BDD1.6050608@kernel.org>
Date: Tue, 08 May 2012 02:31:45 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ming.m.lin@intel.com, hpa@zytor.com, rjw@sisk.pl, x86@kernel.org
Subject: Re: [PATCH] gts and bfs fixes (v3).
References: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh.

I think instead we should go the other way
and simply delete the code
for _GTS and _BFS support.

The evidence is that while it is documented in the ACPI spec,
no OS implements it -- for when we tried it, we found some
systems that shipped AML that doesn't work.

-Len

ps. yes, we should also petition the ACPI authors
to remove _GTS and _BFS from an upcoming revision.
