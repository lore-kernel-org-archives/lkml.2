Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2GBSj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:39:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2GBSj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:39:56 -0400
Date: Mon, 2 Jul 2012 11:39:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: mmotm 2012-06-29-17-00 uploaded
Message-Id: <20120702113955.9f0d8dde.akpm@linux-foundation.org>
In-Reply-To: <4FF180D6.4090205@parallels.com>
References: <20120630000055.AF381A02DE@akpm.mtv.corp.google.com>
	<4FF180D6.4090205@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 15:07:02 +0400
Glauber Costa <glommer@parallels.com> wrote:

> On 06/30/2012 04:00 AM, akpm@linux-foundation.org wrote:
> > * memcg-rename-config-variables.patch
> > * memcg-rename-config-variables-fix.patch
> > * memcg-rename-config-variables-fix-fix.patch
> 
> Hi Andrew,
> 
> Do you intend to fold those ?
> 

yup.  That naming scheme says "remember to fold these".
