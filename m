Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2GCAyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:54:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60205 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2GCAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:54:31 -0400
X-AuditID: 9c93016f-b7bccae00000345c-eb-4ff242c4d4da
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, eranian@google.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<87fw9blyhj.fsf@sejong.aot.lge.com>
	<20120702101518.GC967@krava.redhat.com>
	<1341234662.1476.13.camel@leonhard>
	<20120702133341.GD967@krava.redhat.com>
	<1341238834.1476.50.camel@leonhard>
Date: Tue, 03 Jul 2012 09:50:19 +0900
In-Reply-To: <1341238834.1476.50.camel@leonhard> (Namhyung Kim's message of
	"Mon, 02 Jul 2012 23:20:34 +0900")
Message-ID: <877gulmzw4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jul 2012 23:20:34 +0900, Namhyung Kim wrote:
> We could pass such information to perf report explicitly, But I guess it
> 'd better if perf report did it for me automagically by detecting group
> relations.

Oh I think we can do it by parsing the command line (again) at the perf
report time. In that way, no need to change the file format. I'm gonna
give it a shot later.

Thanks,
Namhyung
