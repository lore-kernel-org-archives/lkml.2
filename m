Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1KWMso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:48:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1KWMsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:48:43 -0500
Message-ID: <1322052511.14799.61.camel@twins>
Subject: RE: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhu, DengCheng" <dczhu@mips.com>
Cc: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 13:48:31 +0100
In-Reply-To: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA9FF@exchdb03.mips.com>
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>
	 ,<1321959115.5148.22.camel@twins>
	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>
	 ,<1321969559.14799.7.camel@twins>
	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com>
	 <1321971798.14799.12.camel@twins> <4ECC6AAC.4010504@mips.com>
	,<1322048382.14799.41.camel@twins>
	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA9FF@exchdb03.mips.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 12:40 +0000, Zhu, DengCheng wrote:
> 
> Ah, yes you are right. Thanks. Your following patch looks good except
> that event_entry should be used for ctx event_list, rather than
> group_entry. 

D'0h yes, I figure the next compile cycle would've caught that. Fixed it
though, thanks!
