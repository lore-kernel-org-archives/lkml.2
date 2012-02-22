Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2BVU6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:58:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab2BVU6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:58:11 -0500
Date: Wed, 22 Feb 2012 12:58:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
Message-Id: <20120222125810.50cd5789.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1202221343530.10125@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
	<20120124135443.2772d455.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr>
	<20120131172334.7f26f164.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
	<20120131174914.8ce5291d.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr>
	<20120131190109.b53347fd.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1202221343530.10125@frira.zrqbmnf.qr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012 13:48:08 +0100 (CET)
Jan Engelhardt <jengelh@medozas.de> wrote:

> task: provide a larger task command buffer

<scratches head>

Why are we bothering ourselves about this?
