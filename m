Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1IBPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:41:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1IBPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:41:34 -0400
Subject: si_swapinfo export
From: George Shuklin <george.shuklin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 19:41:29 +0400
Message-ID: <1314978089.11870.2.camel@mabase>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

Why si_swapinfo (from include/linux/swap.h) is not marked as
EXPORT_SYMBOL_GPL? It's kinda hard to gain information about memory in
module. 

/proc/meminfo Contain more information than module can gain without
special tricks...

Thanks.

