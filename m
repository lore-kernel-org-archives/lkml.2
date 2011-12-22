Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1LVI4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:56:16 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:16734 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1LVI4O convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 22 Dec 2011 03:56:14 -0500
Message-Id: <4EF2FEF1020000780006985F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 22 Dec 2011 08:57:05 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Konrad Rzeszutek Wilk" <konrad@darnok.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Xen: consolidate and simplify struct xenbus_driver
 instantiation
References: <4EF210E7020000780006965E@nat28.tlf.novell.com>
 <20111221173915.GA15377@phenom.dumpdata.com>
In-Reply-To: <20111221173915.GA15377@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.12.11 at 18:39, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> b) this is changing it from xen-pciback to pciback:

Yes, this clearly was unintentional. I'll get a v2 out right away, and also
try to remember Cc-ing the other people you mentioned.

Jan

