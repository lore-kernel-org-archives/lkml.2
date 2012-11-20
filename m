Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2KTULs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:11:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2KTULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:11:47 -0500
Date: Tue, 20 Nov 2012 20:11:42 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Eilon Greenstein <eilong@broadcom.com>
Cc: Joe Perches <joe@perches.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
Message-ID: <20121120201142.GI17797@dm>
References: <20121120115239.GA7955@dm>
 <1353421624.6559.9.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120144329.GE7955@dm>
 <1353424027.6559.15.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120154443.GK7955@dm>
 <1353427570.6559.21.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120161417.GA17797@dm>
 <20121120163607.GB17797@dm>
 <1353438635.10779.10.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120193249.GH17797@dm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120193249.GH17797@dm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:32:49PM +0000, Andy Whitcroft wrote:
> On Tue, Nov 20, 2012 at 09:10:35PM +0200, Eilon Greenstein wrote:
> 
> > About the logic - true, if diff will show deleted lines after newly
> > added lines, some new double line segments will be missed. However, it
> > seems like few other things will break if diff will start acting out
> > like that. The suggestion you posted earlier will miss those as well,
> > and starting to check for this weird case (of deleted lines after the
> > added lines) does not seem right.
> 
> Actually the version I sent should indeed cope with the deleted lines
> regardless of order.  It was cirtainly intended to.

... and I think I thought of a couple more corner cases neither solution
will find.  So I am going to go away and make up a proper set of tests
for this apparently simple change.  As it is really annoying when it
false positives.  I will post against when I have something which works.

-apw
