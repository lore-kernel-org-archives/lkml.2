Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1FNUYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 16:24:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:13002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab1FNUYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 16:24:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,366,1304319600"; 
   d="scan'208";a="16208778"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCH 0/2] N_GSM bugfix patchset : June 14, 2011
Date: Tue, 14 Jun 2011 13:23:27 -0700
Message-Id: <1308083009-9218-1-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 0/2] N_GSM bugfix patchset : June 14, 2011>
References: <[PATCH 0/2] N_GSM bugfix patchset : June 14, 2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello N_GSM Maintainers,

I'm sending this patchset

[PATCH 0/2] N_GSM bugfix patchset : June 14, 2011

for inclusion in the linux kernel.
This contains the 2 bugfixes separated from the patchset
N_GSM patchset : 06/03/2011: v2
as requested by GregH 


[PATCH 1/2] tty: n_gsm: Fixed logic to decode break signal from modem status
[PATCH 2/2] tty: n_gsm: improper skb_pull() use was leaking framed data
