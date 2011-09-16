Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1IPSNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:13:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1IPSNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:13:20 -0400
Date: Fri, 16 Sep 2011 14:13:08 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: andi@firstfloor.org, gregkh@suse.de, willy@meta-x.org,
        paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org
Message-ID: <20110916181307.GW10700@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org
Bcc: 
Subject: stable patch queues and submission
Reply-To: 

Hi All,

With kernel.org being down, the stable@kernel.org list is no longer
working.  This leaves me wondering if we should send patches directly to
the various stable tree maintainers with [stable] in the prefix and
linux-kernel CC'd, or if the stable queues are even being maintained
during the outage.

Does anyone have a preference or suggestion on how to continue stable
releases until the list comes back?  (I'm assuming 'wait' isn't really a
best all around option.)

josh
