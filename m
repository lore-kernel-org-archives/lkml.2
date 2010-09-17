Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0IQTsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 15:48:04 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1105 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0IQTsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 15:48:03 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Brett Rudley" <brudley@broadcom.com>
To: "tim.gardner@canonical.com" <tim.gardner@canonical.com>
cc: "Greg KH" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>,
        "Nohee Ko" <noheek@broadcom.com>
Date: Fri, 17 Sep 2010 11:39:53 -0700
Subject: RE: [PATCH] staging: brcm80211: Make CFLAGS explicit
Thread-Topic: [PATCH] staging: brcm80211: Make CFLAGS explicit
Thread-Index: ActWlunGguE28IjYSaqwNkE6hd+AAQAABnqA
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE12BEC65C1F@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
 <20100917162142.GA30385@suse.de> <4C93A8F9.9090108@canonical.com>
 <7A94256FD72B884D9E7C55586C3CBCEE12BEC65BEC@SJEXCHCCR01.corp.ad.broadcom.com>
 <4C93B486.8050706@canonical.com>
In-Reply-To: <4C93B486.8050706@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: 0lE= D/7H FHBP GRk5 Lua0 MoCn M40w Qtwh REZo YQv+
 Z0YQ cKsg eX04 fGZu fTJL
 hH3K;3;ZwByAGUAZwBrAGgAQABzAHUAcwBlAC4AZABlADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAaQBtAC4AZwBhAHIAZABuAGUAcgBAAGMAYQBuAG8AbgBpAGMAYQBsAC4AYwBvAG0A;Sosha1_v1;7;{2AC5BB31-DD8A-44C6-A0DF-05CB9979B9DD};YgByAHUAZABsAGUAeQBAAGIAcgBvAGEAZABjAG8AbQAuAGMAbwBtAA==;Fri,
 17 Sep 2010 18:39:53
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAcwB0AGEAZwBpAG4AZwA6ACAAYgByAGMAbQA4ADAAMgAxADEAOgAgAE0AYQBrAGUAIABDAEYATABBAEcAUwAgAGUAeABwAGwAaQBjAGkAdAA=
x-cr-puzzleid: {2AC5BB31-DD8A-44C6-A0DF-05CB9979B9DD}
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 608D1A4247864138-04-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Don't you have the orientation inverted? WLC_LOW is defined for a
> PCI NIC.

Both LOW and HIGH are used for NIC.  That is to say everything runs on the host.

On splitmac dongle, only the HIGH runs on the host while the LOW runs on the dongle.

Both models run the HIGH code on the host.

Brett

