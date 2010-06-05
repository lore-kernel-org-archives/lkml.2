Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab0FEXlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:41:36 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:58950 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab0FEXle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=m96F/iKfOm95t3R7lv++AZVKhmOKAq+chZE/OGTz2pGrLS8kEf4imxPhkClqWsPKbF
         yOtiVo1J4ZC/gsIaUzxdAlkaVQh6qX+4zDQBeeR/Cu8L9SapKExE7ZnV5ZUIGpH2fur4
         ZbULQRBqCo2HW2NhWz/wSOJIUMYOdYH1vWLY0=
MIME-Version: 1.0
Date: Sun, 6 Jun 2010 07:41:34 +0800
Message-ID: <AANLkTikb5jAw_fSQ08IMrzwKK7lfafXlm63S46F-C8m0@mail.gmail.com>
Subject: [Q] Perf-events callchain support on MIPS
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: mingo@elte.hu, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter and Ingo


For MIPS, recording user stack backtrace in the kernel is not quite as easy
as on other platforms. Because In the kernel, we don't have frame unwinder
to work on the user stack. Given the different possible compiler flags,
getting the backtrace for the user stack is especially challenging.

So, is it still useful to implement the Perf-events callchain support on
MIPS with only kernel addresses recorded for now? What impact do you see to
do so? Only that the user can not see user-level performance bottleneck?


Thanks!

Deng-Cheng
