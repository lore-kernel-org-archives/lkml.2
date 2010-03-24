Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0CXHxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:53:55 -0400
Received: from mail.atheros.com ([12.36.123.2]:45664 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0CXHxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:53:54 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19369.51647.544760.353002@gargle.gargle.HOWL>
Date: Wed, 24 Mar 2010 13:43:51 +0530
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
In-Reply-To: <20100324155930.1fa3367b.sfr@canb.auug.org.au>
References: <20100324155930.1fa3367b.sfr@canb.auug.org.au>
X-Mailer: VM 8.0.12 under 23.1.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi John,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 

Thanks for reporting this.
A patch has been sent to fix this issue: https://patchwork.kernel.org/patch/87829/

Sujith
