Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2IZCwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:52:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44905 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2IZCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:52:11 -0400
MIME-Version: 1.0
Date: Wed, 26 Sep 2012 11:52:11 +0900
Message-ID: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
Subject: [QUESTION] Can uprobe_event support @ADDR, $retval, offs(FETCHARG)?
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: srikar@linux.vnet.ibm.com
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

uprobe_event only supports %REG arguments. I think that memory fetch,
return value fetch, memory dereference functions in
kernel/trace/trace_probe.c are good for uprobe_event. So with a little
modification of parse_probe_arg(), uprobe_event can support @ADDR,
$retval, offs(FETCHARGS) except @SYM, $stack, $stackN. Is it right?

Thanks,
Hyeoncheol
