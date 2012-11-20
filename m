Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2KTTcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:32:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2KTTcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:32:53 -0500
Date: Tue, 20 Nov 2012 19:32:49 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Eilon Greenstein <eilong@broadcom.com>
Cc: Joe Perches <joe@perches.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
Message-ID: <20121120193249.GH17797@dm>
References: <1353151057.14327.18.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120115239.GA7955@dm>
 <1353421624.6559.9.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120144329.GE7955@dm>
 <1353424027.6559.15.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120154443.GK7955@dm>
 <1353427570.6559.21.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120161417.GA17797@dm>
 <20121120163607.GB17797@dm>
 <1353438635.10779.10.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353438635.10779.10.camel@lb-tlvb-eilong.il.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 09:10:35PM +0200, Eilon Greenstein wrote:

> About the logic - true, if diff will show deleted lines after newly
> added lines, some new double line segments will be missed. However, it
> seems like few other things will break if diff will start acting out
> like that. The suggestion you posted earlier will miss those as well,
> and starting to check for this weird case (of deleted lines after the
> added lines) does not seem right.

Actually the version I sent should indeed cope with the deleted lines
regardless of order.  It was cirtainly intended to.

-apw
