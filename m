Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab1FPVUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:20:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:4512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1FPVUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="14474055"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 0/2] N_GSM: RAW_IP Support : June 16, 2011
Date: Thu, 16 Jun 2011 14:20:11 -0700
Message-Id: <1308259213-31887-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/2] N_GSM: RAW_IP Support : June 16, 2011>
References: <[PATCH 0/2] N_GSM: RAW_IP Support : June 16, 2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello N_GSM Maintainers,

I'm sending this patchset

"N_GSM: RAW_IP Support : June 16, 2011"

for inclusion in the linux kernel.

This contains the 2 patches.
One implements RAWIP support using one of the MUX channels, and the other
patch implements reference count freeing of common structures shared
between the MUX core code and the individual MUX channel clients.

[PATCH 1/2] tty: n_gsm: Add raw-ip support
[PATCH 2/2] tty: n_gsm: Added refcount usage to gsm_mux and gsm_dlci structs
