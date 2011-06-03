Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1FCXoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:44:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:47390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1FCXoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,317,1304319600"; 
   d="scan'208";a="13344046"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2
Date: Fri,  3 Jun 2011 16:43:55 -0700
Message-Id: <1307144642-5915-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
References: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello N_GSM Maintainers,

I'm sending this patchset

[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2

This patchset is the same as version 1 except it contains 2
additional patches that are needed to make the network interface
functionality usable.
These are the pertinent changes that we have done to the driver.
Thank you for yor comments.

[PATCHv2 1/7] tty: n_gsm: Add raw-ip support
       - Added netif glue so a DLCI can map to a network IF
[PATCHv2 2/7] tty: n_gsm: expose gsmtty device nodes at ldisc open time
       - Caused gsmttyN device nodes to be exposed automatically.
[PATCHv2 3/7] tty: n_gsm: Added refcount usage to gsm_mux and gsm_dlci structs
       - added refcount access to struct shared between MUX and
         channel clients
[PATCHv2 4/7] tty: n_gsm: initiate close of all DLCIs during mux shutdown
[PATCHv2 5/7] tty: n_gsm: Fixed NULL ptr OOPs in tty_write_room()
[PATCHv2 6/7] tty: n_gsm: Fixed logic to decode break signal in modem status
[PATCHv2 7/7] char: n_gsm: improper skb_pull() use was leaking framed data
