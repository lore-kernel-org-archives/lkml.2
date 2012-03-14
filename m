Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030789Ab2CNNjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2CNNjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:39:51 -0400
Subject: RE: [Linux-c6x-dev] [PATCH 06/35] Disintegrate asm/system.h for C6X
 [ver #2]
From: Mark Salter <msalter@redhat.com>
To: "Jacquiot, Aurelien" <a-jacquiot@ti.com>
Cc: David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Date: Wed, 14 Mar 2012 09:39:45 -0400
In-Reply-To: <553CFBBAF1315044BC4CD328C97B0B1C17FA0A76@DNCE02.ent.ti.com>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	 <20120312233706.13888.5678.stgit@warthog.procyon.org.uk>
	 <1331728169.2167.2.camel@deneb.redhat.com>
	 <553CFBBAF1315044BC4CD328C97B0B1C17FA0A76@DNCE02.ent.ti.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331732387.2167.9.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 13:29 +0000, Jacquiot, Aurelien wrote:
> Mark,
> 
> Are you sure about the #define _ASM_C6X_BARRIER_H in exec.h?
> _ASM_C6X_EXEC_H sounds better...

Thanks! Copy and paste mistake. FYI, I plan on getting rid of the
C6X version and using the generic version once it is available.



