Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2HNLb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:31:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40543 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2HNLb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:31:57 -0400
MIME-Version: 1.0
Date: Tue, 14 Aug 2012 17:01:56 +0530
Message-ID: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
Subject: How to hack syscall-table, in kernel 2.6+ ?
From: Ajay Garg <ajaygargnsit@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

It is well known that the syscall-table had stopped being exported
from version 2.6 onwards.

So, now as a developer, if I wish to hack into the syscall-table, and
change the syscall-function-pointers to my custom-function-pointers
(mainly for the reason of adding/preventing access to certain files,
via Kernel-Loadable-Modules), what is the recommended way?

I have already tried extracting the address of the "sys_call_table"
from "System.Map"; however, I am still not able to replace the
function-pointers with mine.
Trying to do gives me page-faults, apparently meaning that the
syscall-table memory area is read-only.



I will be grateful, if someone could point me to the recommended way
of doing this.


Thanks and Regards,
Ajay
