Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1BQKjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:39:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33538 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337Ab1BQKjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:39:36 -0500
Date: Thu, 17 Feb 2011 10:39:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Justin TerAvest <teravest@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
Message-ID: <20110217103923.5e59526e@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=L5gingbYVDZfuDdkCyUKXNhjz8zFg4FLBN+7L@mail.gmail.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
	<4D539821.1090703@cn.fujitsu.com>
	<AANLkTi=L5gingbYVDZfuDdkCyUKXNhjz8zFg4FLBN+7L@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CodingStyle says we should only have one declaration per line.

CodingStyle is a guide not a religious document at over which common
sense deviations should be sacrificed

