Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1FUJ4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:56:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53302 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab1FUJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DpwzndyhtSHC7eIHekJx8NgEopTGfjOYrYBKBU5kH+eQbx//gp6HclDB2HMt6u+aOx
         jSsjYVJF+sp1uzypJ/qQr0NYECxFVbsNYepueRCpZqorBUZOb/yOIW4IiEUPmqniTogm
         OEY0CZs+JD/ONb4V+s2ovmkr5x9wRYUB7pe00=
Date: Tue, 21 Jun 2011 10:57:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc3 kmemleak reports
Message-ID: <20110621095733.GA10396@1n450.cable.virginmedia.net>
References: <itpou0$leu$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <itpou0$leu$1@dough.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:40:15AM +0200, Bernd Schubert wrote:
> For some reasons I build a kernel with kmemleak support and got a
> few reports.

Do you know if they appear in 2.6.39 as well?

Thanks.

-- 
Catalin
