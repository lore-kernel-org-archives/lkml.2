Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1HXOYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:24:47 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:32990 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750891Ab1HXOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:24:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nsnUsAQVM1kB5sK00VRR8YZWYQHQYHxcxbTbvtwfqzc4VsH
 g.vEY0G5vwljvsRGcZx9rs7.tS9BbNomoMZHoz0RiwYMUuiAFseP3p9Yu0sw
 V36oS2VfoPaWTy2URd3.bJVUtpwWbeI3pu2P3GFEQljmFXgf2fohfEcZ_RkQ
 JaYNMBtmmPMva5sIAdSCsW6iuN4ThyBwa3cer5zSbBp4j4NOtemW2HY2flfa
 ITiDqCUOyEwRlLj1hYVasU6bF.mgwakdocri6GEZFqOZ8O.ruqRtegZfssti
 H5tJzGPKgnlU3.tSD4nsRtwuETQ6N4z.0B0yzWwqStPNrcTG4FxsezDotmg4
 qFvKzd_XG3WUOb4hBODU9lR7K4s6YgVjOMeXoVrWCfB3U
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 09:24:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 08/13] list: add a new LRU list type
In-Reply-To: <4E5379DA.8060109@openvz.org>
Message-ID: <alpine.DEB.2.00.1108240923420.24118@router.home>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com> <1314089786-20535-9-git-send-email-david@fromorbit.com> <20110823092056.GE21492@infradead.org> <20110823093205.GZ3162@dastard> <4E5379DA.8060109@openvz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Konstantin Khlebnikov wrote:

> maybe is better to rename it to enum page_lru_list

Better rename both and clearly indicate what type of lru list it is. An
LRU list is such a generic concept that it shows up in an excessive amount
of contexts.

