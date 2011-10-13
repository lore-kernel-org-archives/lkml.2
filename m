Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1JMTDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:03:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:26632 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1JMTDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,342,1315206000"; 
   d="scan'208";a="62328049"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niso@kth.se>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Oct 2011 12:03:20 -0700
Subject: RE: [PATCH] i7core_edac: fix erroneous size of static array
Thread-Topic: [PATCH] i7core_edac: fix erroneous size of static array
Thread-Index: AcyJ2e9PKLmWip5YRV6EtoKihaXKWgAAEwyw
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE87A060@orsmsx505.amr.corp.intel.com>
References: <1318530294-6829-1-git-send-email-niso@kth.se>
 <20111013185656.GC3064@aftab>
In-Reply-To: <20111013185656.GC3064@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	static int cols[8] = {
> +	static int cols[4] = {

Why are these arrays "static"? Does that generate better code than
dynamic initialization?

-Tony
