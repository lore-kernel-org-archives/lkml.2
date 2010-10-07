Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab0JGII0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 04:08:26 -0400
Received: from sunjammer.sugarlabs.org ([140.186.70.53]:57391 "EHLO
	sunjammer.sugarlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0JGIIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 04:08:23 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 04:08:23 EDT
Subject: Re: Issues when running without swap
From: Bernie Innocenti <bernie@codewiz.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: systems <systems@lists.sugarlabs.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1286404202-sup-7870@twin.sascha.silbe.org>
References: <1286404202-sup-7870@twin.sascha.silbe.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Thu, 07 Oct 2010 10:00:20 +0200
Message-ID: <1286438420.11914.48.camel@giskard.codewiz.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Oct 2010 23:54:03 +0200, Ben Hutchings wrote:

> You also told me that this machine had no swap enabled, which is an
> unusual configuration and restricts the ability of the VM to defragment
> memory.  I would recommend adding a small swap file/partition.  However:

Is this behavior documented anywhere? If not, can you point me at the vm
code which implies page defragmentation through swap?

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

