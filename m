Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab0HLJdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:33:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48149 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0HLJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:33:07 -0400
Date: Thu, 12 Aug 2010 02:31:41 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of
 list_for_each_entry loop cursor
Message-ID: <20100812093141.GA6561@mail.oracle.com>
Mail-Followup-To: Julia Lawall <julia@diku.dk>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Sunil Mushran <sunil.mushran@oracle.com>
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
 <20100812000355.GA7195@mail.oracle.com>
 <Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 07:46:13AM +0200, Julia Lawall wrote:
 
> This seems a bit ugly to me, since it exposes the implementation of the 
> list abstraction.  What about the following:

	Actually, we're going to go back to the original list_for_each()
and list_entry() version.  It's a well understood idiom.
	We're also going to re-audit the rest of the patch that changed
list_for_each() to list_for_each_entry(), just in case we missed another
semantic error.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
