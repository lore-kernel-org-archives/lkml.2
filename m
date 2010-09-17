Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0IQSDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:03:42 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3318 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0IQSDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:03:41 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Brett Rudley" <brudley@broadcom.com>
To: "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "Greg KH" <gregkh@suse.de>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>,
        "Nohee Ko" <noheek@broadcom.com>
Date: Fri, 17 Sep 2010 11:03:14 -0700
Subject: RE: [PATCH] staging: brcm80211: Make CFLAGS explicit
Thread-Topic: [PATCH] staging: brcm80211: Make CFLAGS explicit
Thread-Index: ActWkAPfq2x3IsvGS4WbvxJooAWrJwAAEZPA
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE12BEC65BEC@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
 <20100917162142.GA30385@suse.de> <4C93A8F9.9090108@canonical.com>
In-Reply-To: <4C93A8F9.9090108@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Bv5l DPxA Fx7F H1Tm JKO9 JfiJ LUtT MuWK OuOO VME/
 XBJO XHCi YtfY ZHYK ZH26
 cCpi;3;ZwByAGUAZwBrAGgAQABzAHUAcwBlAC4AZABlADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAaQBtAC4AZwBhAHIAZABuAGUAcgBAAGMAYQBuAG8AbgBpAGMAYQBsAC4AYwBvAG0A;Sosha1_v1;7;{00511298-511F-4A94-BEC7-247428752C37};YgByAHUAZABsAGUAeQBAAGIAcgBvAGEAZABjAG8AbQAuAGMAbwBtAA==;Fri,
 17 Sep 2010 18:03:14
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAcwB0AGEAZwBpAG4AZwA6ACAAYgByAGMAbQA4ADAAMgAxADEAOgAgAE0AYQBrAGUAIABDAEYATABBAEcAUwAgAGUAeABwAGwAaQBjAGkAdAA=
x-cr-puzzleid: {00511298-511F-4A94-BEC7-247428752C37}
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 608D72E33N0395250-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In a split mac dongle, the HIGH code runs on the host processor while the LOW code runs on the dongle and the two talk across an RPC API over SDIO or USB.

On a NIC both HIGH and LOW run on the host and the RPC API remains identical but the APIs become function straight calls.
 
This lets us use the same code and API in both models.

Getting some documentation out on this is in TODO list.  

Brett

> What does WLC_LOW and WLC_HIGH mean anyway?
> 
> rtg
> --
> Tim Gardner tim.gardner@canonical.com


