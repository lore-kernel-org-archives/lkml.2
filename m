Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1GKQwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:52:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32794 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab1GKQwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>
Date: Tue, 12 Jul 2011 00:52:30 +0800
Message-ID: <CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
Subject: how to find a task through name faster?
From: loody <miloody@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
I found a way to find a task I need by name, test,  as below:
for_each_process(task) {
    if(strcmp(task->comm, "test")
        printk(“%s[%d]\n”, task->comm, task->pid);
}

But it is time-consuming to do so if I periodically want to know
whether "test" exist or not.
is there better way to do so?

--
Regards,



--
Regards,
