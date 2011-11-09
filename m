Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1KIQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:14:48 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:40860 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KIQOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:14:46 -0500
X-IronPort-AV: E=Sophos;i="4.69,484,1315180800"; 
   d="scan'208";a="8844890"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: annie li <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 9 Nov 2011 16:14:51 +0000
Subject: RE: [PATCH 1/3] Introducing grant table V2 stucture
Thread-Topic: [PATCH 1/3] Introducing grant table V2 stucture
Thread-Index: Acye+dkSPeFs66I4SLaoqnjbJAaG5gAAC9+A
Message-ID: <291EDFCB1E9E224A99088639C4762022B4543AB213@LONPMAILBOX01.citrite.net>
References: <4EBA35D3.3020506@oracle.com>
 <1320826490-29362-1-git-send-email-annie.li@oracle.com>
 <291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>
 <4EBAA566.80909@oracle.com>
In-Reply-To: <4EBAA566.80909@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annie,

On 2011-11-9 19:11, Paul Durrant wrote: 
> I see. v2 function includes mapping and arch_gnttab_map_shared, v1 function only include arch_gnttab_map_sh, right?
> This will lead to some code duplicated in two functions. 

My preference would be to have duplicated calls to arch_gnttab_map_shared(). I think it's more illustrative of the difference between v1 and v2 having separate status pages.

  Paul
