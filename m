Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2FNQXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2FNQXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:23:07 -0400
Date: Thu, 14 Jun 2012 12:22:57 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 3.5.rc2 tty buffering bug ?
Message-ID: <20120614162257.GA5238@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20120614161331.GA29687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614161331.GA29687@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 12:13:31PM -0400, Dave Jones wrote:
 
 > #include <stdio.h>
 > 
 > void main()
 > {
 > 	printf("begin\n");
 > 
 > 	if (fork() != 0)
 > 		printf("child\n");
 > 	else
 > 		printf("parent\n");
 > 
 > 	printf("end\n");
 > }
 > 
 > How does 'begin' get printed a second time ?

Someone pointed out that an fflush is needed before the fork.
Somehow I've managed to go all these years without knowing that.

	Dave

 
