Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0G1Ukd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:40:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34103
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756129Ab0G1UkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:40:13 -0400
Date: Wed, 28 Jul 2010 13:40:30 -0700 (PDT)
Message-Id: <20100728.134030.267939322.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 07/12] jump label v10: use lib/sort.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <59e3532f43294252ff34468bbbf0444c589f0956.1280263065.git.jbaron@redhat.com>
References: <cover.1280263065.git.jbaron@redhat.com>
	<59e3532f43294252ff34468bbbf0444c589f0956.1280263065.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Tue, 27 Jul 2010 16:54:36 -0400

> Make use of the the kernel's generic sort routines.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Again, this should be incorporated into the first patch.

It's a new feature, so whatever refinements occur over time should be
incorporated into the patch that adds the new feature.
