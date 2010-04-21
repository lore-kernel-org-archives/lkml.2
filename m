Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0DUSXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0DUSXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:23:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix a race in creds_are_invalid() in credentials
	debugging
In-Reply-To: David Howells's message of  Wednesday, 21 April 2010 10:28:25 +0100 <20100421092825.19520.48557.stgit@warthog.procyon.org.uk>
References: <20100421092825.19520.48557.stgit@warthog.procyon.org.uk>
X-Shopping-List: (1) Insolent compasses
   (2) Elastic Garden Weasel bogs
   (3) Eccentric yies
   (4) Perfidious preserves suspicions
   (5) Repetitious annoyer thunder
Message-Id: <20100421182301.9EE26B05E@magilla.sf.frob.com>
Date: Wed, 21 Apr 2010 11:23:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you should submit this for 2.6.3[23]-stable too.


Thanks,
Roland
