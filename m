Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0ELNkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:40:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0ELNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:40:30 -0400
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Peter Zijlstra <peterz@infradead.org>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1273669541.3086.24.camel@localhost>
References: <1273669541.3086.24.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 15:40:27 +0200
Message-ID: <1273671627.1626.116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 15:05 +0200, Dhaval Giani wrote:
> Where cpusets goes wrong is to have a *no* default values.

It has a default, empty is still a valid value.


