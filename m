Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2BAA0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:26:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52818 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752050Ab2BAA0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:26:17 -0500
Message-ID: <1328055976.14714.7.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] coda: Remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Date: Tue, 31 Jan 2012 16:26:16 -0800
In-Reply-To: <4F2885EC.8070900@gmail.com>
References: <cover.1328049542.git.joe@perches.com>
	 <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>
	 <4F288178.4040405@gmail.com> <1328055665.14714.5.camel@joe2Laptop>
	 <4F2885EC.8070900@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 11:23 +1100, Ryan Mallon wrote:
> On 01/02/12 11:21, Joe Perches wrote:
> > Maybe because alloc/free functions are
> > used relatively infrequently, maybe it'd
> > be better to not declare the functions
> > inline but add them to coda_linux.c
> Sure, either approach is fine. Do you want to add the patch to your series?

I think Jan can work it out properly if he wants it.


