Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2BOPtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:49:09 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:33805 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab2BOPtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:49:07 -0500
Subject: Re: [PATCH 21/40] OpenRISC: Don't reimplement force_sigsegv()
From: Matt Fleming <matt@console-pimps.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net
In-Reply-To: <1329320456.2670.86.camel@crucifix>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <1329219673-28711-22-git-send-email-matt@console-pimps.org>
	 <1329320456.2670.86.camel@crucifix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 15:49:05 +0000
Message-ID: <1329320945.3675.149.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 16:40 +0100, Jonas Bonn wrote:
> Acked-by: Jonas Bonn <jonas@southpole.se>
> 
> ...for OpenRISC, all 4 patches (20-23 in this series).
> 
> Should I take these in the OpenRISC tree or how did you want to do?

Whatever you prefer. Feel free to take them through the OpenRISC tree.

-- 
Matt Fleming, Intel Open Source Technology Center

