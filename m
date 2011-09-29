Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1I2OMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:12:01 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:38294 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751133Ab1I2OL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:11:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Hx13eyQVM1kQ1fSSNfAJNSWgZO49Tk9lfgFDMFVKlUPD73K
 cJ8j1o8zBAPyKh5CsfCd_vUEZEZF_vL3PKPzmIV6_Rx_.wryxATZhhfza9sR
 fqev3THQ1i75c43DGdCSSTeVqjZ9UZ8XfCF9hUyFv..xGKCdIP8NdH8r7QUK
 OqJonuLX_8OUt6woKgIpbX_sm_50rINSOdYflmOo37jiwBCdn4ClJPJ5b5Ib
 8ykIKW4A2kAQ1ohN6KI0kGle5Y7ZPPXU9GtZ2mjJnZx05iepYamMqOepP8Xm
 Kz0x4d8wmEoWbQcN5HXHRdeoB4AEV5m5djD0037tkUXR20crn9hMY8zGvdwV
 YNEz_gZYLSQFVB4G1z7nZyBDddch6.i8XMj8srdHeXR9wW0tsox6OYXGqkUs
 qt79KFvU3y360vHhl
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 29 Sep 2011 09:11:54 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Valdis.Kletnieks@vt.edu
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: <30918.1317257024@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.00.1109290911080.9382@router.home>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home> <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com> <alpine.DEB.2.00.1109271546320.13797@router.home>
            <1317241905.16137.516.camel@nimitz> <30918.1317257024@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011, Valdis.Kletnieks@vt.edu wrote:

> > We could also give the imprecise numbers to unprivileged
> > users and let privileged ones see the page-level ones.
>
> That also sounds like a good idea.

Uhh... Another source of confusions for the uninitiated.

