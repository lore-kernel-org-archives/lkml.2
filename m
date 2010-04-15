Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0DOULL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:11:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab0DOULI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:11:08 -0400
Date: Thu, 15 Apr 2010 17:10:58 -0300
From: Glauber Costa <glommer@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 5/5] add documentation about kvmclock
Message-ID: <20100415201057.GB14158@mothafucka.localdomain>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <1271356648-5108-3-git-send-email-glommer@redhat.com>
 <1271356648-5108-4-git-send-email-glommer@redhat.com>
 <1271356648-5108-5-git-send-email-glommer@redhat.com>
 <1271356648-5108-6-git-send-email-glommer@redhat.com>
 <20100415122836.27f1e255.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415122836.27f1e255.randy.dunlap@oracle.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 12:28:36PM -0700, Randy Dunlap wrote:
> On Thu, 15 Apr 2010 14:37:28 -0400 Glauber Costa wrote:
> 
Thanks Randy,

All coments relevant. I'll update the document to cover them.

As for your question: Both bit 3 and 0 are used, yes. But they
tell the guest to use a different MSR pair. However, this document
is intented for people not familiar with kvmclock. If you read it,
and could not extract that from the text, it definitely needs to
be augmented.

Thanks!
