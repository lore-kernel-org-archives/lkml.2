Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1FCTEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:04:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:60936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1FCTEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:04:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,315,1304319600"; 
   d="scan'208";a="13242364"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 0/5] N_GSM patchset : 06/03/2011
Date: Fri,  3 Jun 2011 12:03:36 -0700
Message-Id: <1307127821-21665-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello N_GSM Maintainers,

I'm sending this patchset for your consideration.
These are the pertinent changes that we have done to the driver.
Thank you for yor comments.

[PATCH 1/5] tty: n_gsm: Add raw-ip support
       - Added netif glue so a DLCI can map to a network IF
[PATCH 2/5] tty: n_gsm: expose gsmtty device nodes at ldisc open time
       - Caused gsmttyN device nodes to be exposed automatically.
[PATCH 3/5] tty: n_gsm: Added refcount usage to gsm_mux and gsm_dlci structs
       - added refcount access to struct shared between MUX and
         channel clients
[PATCH 4/5] tty: n_gsm: initiate close of all DLCIs during mux shutdown
[PATCH 5/5] tty: n_gsm: Fixed NULL ptr OOPs in tty_write_room()
