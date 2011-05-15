Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab1EOQMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:12:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:46379 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab1EOQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:12:08 -0400
Date: Sun, 15 May 2011 18:10:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] I don't like dmi_name_in_vendors
Message-ID: <20110515181034.1af84279@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of dmi_name_in_vendors() looks pretty
wrong/useless to me, here's a proposal to make it better.

[PATCH 1/2] PCI: Don't use dmi_name_in_vendors in quirk
[PATCH 2/2] Make dmi_name_in_vendors more focused

Comments/opinions welcome.

-- 
Jean Delvare
