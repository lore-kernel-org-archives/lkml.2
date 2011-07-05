Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1GEQnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:43:50 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:56745 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1GEQni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:43:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 01/40] Staging: hv: storvsc: Do not aquire an
 unnecessary reference on stor_device
Thread-Topic: [PATCH 01/40] Staging: hv: storvsc: Do not aquire an
 unnecessary reference on stor_device
Thread-Index: AQHMNmgJr4khra73KUG97wusD5OiY5TeZasA//+SvZA=
Date: Tue, 5 Jul 2011 16:43:36 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816CCF3@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <20110705161408.GA25532@kroah.com>
In-Reply-To: <20110705161408.GA25532@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, July 05, 2011 12:14 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 01/40] Staging: hv: storvsc: Do not aquire an unnecessary
> reference on stor_device
> 
> On Wed, Jun 29, 2011 at 07:38:58AM -0700, K. Y. Srinivasan wrote:
> > On entry into storvsc_on_io_completion() we have already acquired a
> reference
> > on the stor_device; there is no need to acquire an additional reference here.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> This series doesn't apply anymore, care to redo it?

Will do. 

K. Y

