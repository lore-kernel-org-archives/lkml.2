Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2AWFcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 00:32:36 -0500
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:45768 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2AWFcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 00:32:35 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:Date:
   Subject:Thread-Topic:Thread-Index:Message-ID:
   Accept-Language:Content-Language:X-MS-Has-Attach:
   X-MS-TNEF-Correlator:x-cr-puzzleid:x-cr-hashedpuzzle:
   acceptlanguage:Content-Type:Content-Transfer-Encoding:
   MIME-Version;
  b=E+ERKub2sHhx1eNYcuESU3Vn4aqG/3SERUJNO1dNBKmYrk5KjYmAy4rv
   wFNPICa/fUZzqefOQcFffFe/gTKJJmwq0EVzC7BY+uqbnvzEs7BDN7TfA
   Ln+ZgSv/K9zi7wtFcsG9MxCWevBnJ6ICsokUs6P6vYxLrVZBwD6rAzsD6
   /FwolWORswLHtHjIKHsfT1f6GFy+GUzF4tjDjEby5wDyBLfw2Qjzbcqmo
   jbU/wJdwzvg/9qaFBgFS53tZnM9NB;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.71,554,1320620400"; 
   d="scan'208";a="99360188"
From: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Jan 2012 06:32:28 +0100
Subject: Transparent huge pages and shmem?
Thread-Topic: Transparent huge pages and shmem?
Thread-Index: AczZkGULFJ5jo5aOTZOy8O0OWCfQfQ==
Message-ID: <CB1B361E45A85849902B25342E88900501F504CDD753@ABGEX70E.FSC.NET>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {AFF6978E-B605-4692-BBC1-36EC0B02C956}
x-cr-hashedpuzzle: ACXL BYrb CtCc C3sR DCz2 Dj/i ENR1 E5hN GnTu HQcy ILkP
 IRGW IRby It3Y I3LL
 I3q/;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{AFF6978E-B605-4692-BBC1-36EC0B02C956};YQBuAGQAcgBlAHkALgBiAG8AcgB6AGUAbgBrAG8AdgBAAHQAcwAuAGYAdQBqAGkAdABzAHUALgBjAG8AbQA=;Mon,
 23 Jan 2012 05:32:28
 GMT;VAByAGEAbgBzAHAAYQByAGUAbgB0ACAAaAB1AGcAZQAgAHAAYQBnAGUAcwAgAGEAbgBkACAAcwBoAG0AZQBtAD8A
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of THP enabled kernel - will THP be used for SysV shmem? The obvious target is to avoid pre-allocation of huge pages pool for databases like Oracle that is required today.

Thank you!


---
With best regards

Andrey Borzenkov
Senior system engineer
Service operations

