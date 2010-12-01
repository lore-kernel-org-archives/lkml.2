Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0LAPBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:01:36 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44677 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751173Ab0LAPBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:01:35 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dDnalm0VM1nn3oPaigNYEbJOEWegpXeLyy1w9swD_MUos42
 jfW42qw7t.p7LvVItYrgLkBPjtPRqiAXsiIkctScszujtFzpc4Ne1K21dBPk
 MzJvJmrqcsq4a_OgLAt4XpCkEHPYeMmIuwltiE9OF2eobMQrav9.QKgLjGSk
 hKXXJk42DrHq7aizj3yShdV2zZqKfndiEOiApa.cOZyY6YGrddCUvcOKIu1l
 AvTIeiWM90wpidAJy78odibwL_qvVlBQ6sgU82khzuXm6d.fFHAKp6uOhfwp
 CC1E7a1MrVzm1Os58XtI.
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Dec 2010 09:01:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
In-Reply-To: <20101130142509.4f49d452.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1012010859020.2849@router.home>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6> <20101130101602.17475.32611.stgit@localhost6.localdomain6> <20101130142509.4f49d452.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Andrew Morton wrote:

> > +#define UNMAPPED_PAGE_RATIO 16
>
> Well.  Giving 16 a name didn't really clarify anything.  Attentive
> readers will want to know what this does, why 16 was chosen and what
> the effects of changing it will be.

The meaning is analoguous to the other zone reclaim ratio. But yes it
should be justified and defined.

> > Reviewed-by: Christoph Lameter <cl@linux.com>
>
> So you're OK with shoving all this flotsam into 100,000,000 cellphones?
> This was a pretty outrageous patchset!

This is a feature that has been requested over and over for years. Using
/proc/vm/drop_caches for fixing situations where one simply has too many
page cache pages is not so much fun in the long run.

