Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1FHKaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:30:07 -0400
Received: from mail.bbaw.de ([194.95.188.6]:50722 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab1FHKaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:30:05 -0400
Date: Wed, 8 Jun 2011 12:30:03 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-Id: <20110608123003.3569604f.taeuber@bbaw.de>
In-Reply-To: <20110606095127.21d23a70.taeuber@bbaw.de>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.5.12; VDF: 7.11.9.95; host: mailhub); id=26343-aGcsBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I just tested again with different accoustic managment settings (128 and 254)
in all disks.
The problem still remains.

Am I the only one using SW-RAID6 and having this problem?

I have several other SW-RAID6s productivly running. But they all have at
least 12 disks in an array and are very much older (HW + SW).

Newer running machines have at least 16 disks running (2.6.35).

Should I test older kernels than 2.6.32?

Please help me.
The box is ready to run all test you suggest me to run.

Thanks
Lars
