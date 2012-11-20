Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2KTU1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:27:11 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2663 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2KTU1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:27:10 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1353443183.10779.12.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Andy Whitcroft" <apw@canonical.com>
cc: "Joe Perches" <joe@perches.com>, "David Rientjes" <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Tue, 20 Nov 2012 22:26:23 +0200
In-Reply-To: <20121120201142.GI17797@dm>
References: <20121120115239.GA7955@dm>
 <1353421624.6559.9.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120144329.GE7955@dm>
 <1353424027.6559.15.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120154443.GK7955@dm>
 <1353427570.6559.21.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120161417.GA17797@dm> <20121120163607.GB17797@dm>
 <1353438635.10779.10.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120193249.GH17797@dm> <20121120201142.GI17797@dm>
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CB539123P86553480-03-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 20:11 +0000, Andy Whitcroft wrote:
> > 
> > Actually the version I sent should indeed cope with the deleted lines
> > regardless of order.  It was cirtainly intended to.
> 
> ... and I think I thought of a couple more corner cases neither solution
> will find.  So I am going to go away and make up a proper set of tests
> for this apparently simple change.  As it is really annoying when it
> false positives.  I will post against when I have something which works.
> 

Thanks Andy!

I will assist in testing it on all the scenarios I have created once you
post it.

I appreciate you taking the time to look into adding a test for this
issue.

Thanks,
Eilon


