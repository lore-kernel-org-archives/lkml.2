Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1CPLTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:19:09 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40718 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1CPLTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:19:02 -0400
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fs/9p: Use updated offset for writing
Date: Wed, 16 Mar 2011 16:48:56 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.35.10-74.fc14.i686.PAE; KDE/4.5.4; i686; ; )
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1300252156-5002-1-git-send-email-mohan@in.ibm.com> <874o73ij6t.fsf@linux.vnet.ibm.com>
In-Reply-To: <874o73ij6t.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103161648.57678.mohan@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011 1:35:46 pm Aneesh Kumar K. V wrote:
> On Wed, 16 Mar 2011 10:39:16 +0530, "M. Mohan Kumar" <mohan@in.ibm.com> 
wrote:
> > Use the updated offset given by generic_write_checks. Without this fix,
> > even if a file is opened in O_APPEND mode, data will be written at
> > current file position instead of end of file.

> 
> You should also update offset on success.

Thanks Aneesh, I will send a updated patch.

----
M. Mohan Kumar
