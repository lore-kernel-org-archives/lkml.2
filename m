Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1DYQI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:08:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36620 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1DYQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Q4Q8uPScJFADgEKkeoOiSEoaqdjl44mp7r6sT1NaqmgRPtJY7bvJGLnwVdRMJwEgK9
         eFzBWVGKq/qjxCtiv8RPsFVR7Uzxv2PZycabKBgrHQ97CyfvFauuhnQxTsIDt5u+QjKb
         q7KXYQCmKCvUW6E3WzYySnrgKAAytjYUxykMI=
Subject: [BUG] perf and kmemcheck : fatal combination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Vegard Nossum <vegardno@ifi.uio.no>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 18:08:51 +0200
Message-ID: <1303747731.2747.182.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

Just got a panic on a kmemcheck kernel, latest linux-2.6 tree.

I forgot I had kmemcheck enabled, and started "perf top" just because my
machine was damn slow... Oh well...

Crash in do_nmi -> nmi_enter() -> BUG_ON(in_nmi());

Thanks



