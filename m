Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2H0HXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:23:52 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:45484 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2H0HXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:23:49 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jmorris@namei.org>, <key@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>, <adlai@linux.vnet.ibm.com>,
        <xiaoyan.zhang@intel.com>, <jj@chaosbits.net>
Subject: RE: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Thread-Topic: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Thread-Index: AQHNgLBwseNda/zV6EGrO8CD/jLRy5dnufyAgADXl6CAABF4gIAATd2AgAB0bgCAA+J30A==
Date: Mon, 27 Aug 2012 07:23:40 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440E4B5A@MUCSE501.eu.infineon.com>
References: <20120822215216.GC13519@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208240632120.25506@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com>
 <20120824150533.GA2190@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208250759150.1650@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1208250759150.1650@tundra.namei.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Build using make -> no error.
>>   I can't reproduce this either, James, can you send out your .config?

> See attached.

Hi James,

even with you config, I can't reproduce it here with 3.6-rc3 + mypatch.


Peter
