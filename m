Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2DQRDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:03:53 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63156 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2DQRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:03:52 -0400
Message-ID: <4F8DA274.1070508@gmail.com>
Date: Tue, 17 Apr 2012 13:03:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Doug Ledford <dledford@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@gmail.com
Subject: Re: [Patch 1/8] ipc/mqueue: cleanup definition names and locations
References: <cover.1334676645.git.dledford@redhat.com> <bbf228b7d5f94bd8750083a62f05b6aa51675558.1334676645.git.dledford@redhat.com>
In-Reply-To: <bbf228b7d5f94bd8750083a62f05b6aa51675558.1334676645.git.dledford@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/17/12 11:46 AM), Doug Ledford wrote:
> The various defines for minimums and maximums of the sysctl controllable
> mqueue values are scattered amongst different files and named
> inconsistently.  Move them all into ipc_namespace.h and make them have
> consistent names.  Additionally, make the number of queues per namespace
> also have a minimum and maximum and use the same sysctl function as the
> other two settable variables.
> 
> Signed-off-by: Doug Ledford<dledford@redhat.com>

Ack all of this series.

thanks for patience and good effort.

