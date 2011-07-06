Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1GFVgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:36:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:43357 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab1GFVgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,489,1304319600"; 
   d="scan'208";a="22341706"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Jul 2011 14:36:35 -0700
Subject: RE: [PATCH v2] efi: Fix argument types for SetVariable()
Thread-Topic: [PATCH v2] efi: Fix argument types for SetVariable()
Thread-Index: Acw8HjXTiwbG3XqzScOFeuREC1S2fAABk4lQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301E97969D2@orsmsx505.amr.corp.intel.com>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
 <1309985329-15034-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1309985329-15034-1-git-send-email-mjg@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This version fixes ia64 as well. 

Yes it does.  Thanks Matthew!

Acked-by: Tony Luck <tony.luck@intel.com>
