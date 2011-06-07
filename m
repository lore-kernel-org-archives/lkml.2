Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1FGOy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:54:28 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:36650 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1FGOy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:54:26 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 12/49] Staging: hv: storvsc: Add a DMI signature to
 support auto-loading
Thread-Topic: [PATCH 12/49] Staging: hv: storvsc: Add a DMI signature to
 support auto-loading
Thread-Index: AQHMJJn7CO1NyhiUPk+9dfYcxRT6zJSxarKAgACQ87A=
Date: Tue, 7 Jun 2011 14:54:25 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480813D84D@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-12-git-send-email-kys@microsoft.com>
 <20110606231259.GA18222@infradead.org>
In-Reply-To: <20110606231259.GA18222@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, June 06, 2011 7:13 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 12/49] Staging: hv: storvsc: Add a DMI signature to support
> auto-loading
> 
> On Mon, Jun 06, 2011 at 03:49:36PM -0700, K. Y. Srinivasan wrote:
> > To support auto-loading the storvsc driver, add a DMI signature.
> 
> The storvsc driver is not a DMI driver, but a vmbus driver.  As such it
> should have a vmbus table that is used for autoloading, not a dmi one.
> 

A while ago, Greg introduced DMI signatures to these drivers to support
auto-loading. This signature is not used for anything else. For some reason,
this storvsc driver was missing this signature. I added it again to only support 
auto-loading.

Regards,

K. Y
 
