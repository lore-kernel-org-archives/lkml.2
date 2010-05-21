Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0EUGuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:50:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37343
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab0EUGuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:50:02 -0400
Date: Thu, 20 May 2010 23:50:08 -0700 (PDT)
Message-Id: <20100520.235008.97331614.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: sfr@canb.auug.org.au, greg@kroah.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, therbert@google.com,
       netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree with the net
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1tyq1wy4h.fsf@fess.ebiederm.org>
References: <20100521162134.6b6326bd.sfr@canb.auug.org.au>
	<m1tyq1wy4h.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 20 May 2010 23:46:22 -0700

> It looks right, except perhaps the RPS code looks like it will cause a
> build failure with sysfs disabled, but that has nothing to do with your
> changes.

CONFIG_RPS depends upon CONFIG_SMP && CONFIG_SYSFS, so no that build
failure is not possible.

