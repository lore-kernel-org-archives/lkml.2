Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1IMSw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:52:26 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:48233 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1IMSwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:52:25 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 09/20] Staging: hv: storvsc: Get rid of
 storvsc_dev_add() by inlining the code
Thread-Topic: [PATCH 09/20] Staging: hv: storvsc: Get rid of
 storvsc_dev_add() by inlining the code
Thread-Index: AQHMcjvsHRSV9WmkI0OBY1db3SakjJVMGd+A//+NogA=
Date: Tue, 13 Sep 2011 18:52:23 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E4CB0@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-9-git-send-email-kys@microsoft.com>
 <20110913183941.GA23318@infradead.org>
In-Reply-To: <20110913183941.GA23318@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, September 13, 2011 2:40 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 09/20] Staging: hv: storvsc: Get rid of storvsc_dev_add() by
> inlining the code
> 
> On Tue, Sep 13, 2011 at 10:59:45AM -0700, K. Y. Srinivasan wrote:
> > Get rid of storvsc_dev_add() by inlining the code.
> 
> This also means struct storvsc_device_info can go away, doesn't it?
> 
Yes;  PATCH 11/20 gets rid of struct storvsc_device_info definition and other unneeded state.

Regards,

K. Y
