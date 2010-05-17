Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0EQOLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:11:12 -0400
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:36949 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752090Ab0EQOLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:11:09 -0400
Date: Mon, 17 May 2010 22:11:04 +0800
From: "backyes" <backyes@mail.ustc.edu.cn>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: How to make sure that the process does not encounter the PAGE FAULT after the thread running
Message-ID: <201005172211042966002@mail.ustc.edu.cn>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: yia_0ZC74zV3TvFLAM97BQ--.2968S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUUYxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUjBAYjxAI6xCIbckI1I0E57IF64kEYxAxM7k042IE4asKkaVY67At
	M7k0a2IF6F4UM7kC6x804xWl14x267AKxVWUJVW8JwAFxVCF77xC6IxKo4kEV4yl1I0Esc
	IYIxCEI4klw4CSwwAFIxvE14AKwVWUJVWUGwA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l
	84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s
	0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAawVAYYI1S6c8GOVWUur45Jryln4vE
	4IxY62xKV4CY8xCE548m6r4UJryUGwAqjxCE34x0Y48IcwAqx4xG64xvF2IEw4CE5I8CrV
	C2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UM4x0Y48IcxkI
	7VAKI48JMxAIw28IcxkI7VAKI48JMxCIbVAxMI8E67AF67kF1VAFwI0_Jr0_Jryl34x0Y4
	8IcVAazs8CjcxJYxBIdaVFxhVjvjDU0xZFpf9x07js3ktUUUUU=
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,
How to make sure that the process does not encounter the PAGE FAULT after the thread running. 
Thanks 
--Peter wang


