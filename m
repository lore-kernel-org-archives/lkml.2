Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0JSQjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:39:14 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:60789 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753402Ab0JSQjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:39:12 -0400
Date: Tue, 19 Oct 2010 18:23:01 +0200
From: Helmut Grohne <helmut@subdivi.de>
To: linux-kernel@vger.kernel.org
Subject: Re: "solved" PROBLEM: random crashes while loading modules into
 2.6.36-rc8
Message-ID: <20101019162301.GA10148@alf.mars>
Mail-Followup-To: Helmut Grohne <helmut@subdivi.de>,
	linux-kernel@vger.kernel.org
References: <20101017195206.GA22229@alf.mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017195206.GA22229@alf.mars>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 09:52:06PM +0200, Helmut Grohne wrote:
> I tried to use vanilla 2.6.36-rc8 and failed. While trying track down
> the random oopses, bugs and lockups the problem appeared to get broader
> and broader. In fact the best description I can come up with is loading
> a module with at least one dependency.

This was caused by using binutils-gold. I have no problems with standard
binutils.

Helmut
