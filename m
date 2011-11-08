Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1KHKhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:37:42 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:46895 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192Ab1KHKhl convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Tue, 8 Nov 2011 05:37:41 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 05:37:40 EST
Message-Id: <4EB8EE31020000780005F869@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 Beta 
Date: Tue, 08 Nov 2011 00:54:09 -0700
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kevin Cernekee" <cernekee@gmail.com>
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: Fix performance regression on modules with
 large symbol tables
References: <467be983bed865e1b772136ed488f9ff@localhost>
 <874nygu3cd.fsf@rustcorp.com.au>
 <CAJiQ=7D4SSzzkPpPMGnaTq-wZXUGmXCRfKhYdPFg7APDu+VTwA@mail.gmail.com>
In-Reply-To: <CAJiQ=7D4SSzzkPpPMGnaTq-wZXUGmXCRfKhYdPFg7APDu+VTwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.11.11 at 20:58, Kevin Cernekee <cernekee@gmail.com> wrote:
> We will also want to check the strmap bits, since it's possible that
> "cba_" was a core symbol but "edcba_" is not.  In which case we did not
> allocate room for the "ed" part, back in layout_symtab().

Why would you want to keep the leading part if it's not part of a
core symbol's name?

Jan

