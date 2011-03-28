Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1C1QAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:00:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35669 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1C1QAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:00:07 -0400
Date: Mon, 28 Mar 2011 17:59:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
Message-ID: <20110328155959.GU21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org> <1300914043-2297-3-git-send-email-abogani@kernel.org> <m27hbov7hq.fsf@firstfloor.org> <8739mblr2n.fsf@rustcorp.com.au> <20110325154118.GN21838@one.firstfloor.org> <AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com> <20110325194946.GQ21838@one.firstfloor.org> <AANLkTinYY0vRzVHKqaZghiK=SvFUAVbM5s3Hf6H9C5Pv@mail.gmail.com> <20110326200419.GR21838@one.firstfloor.org> <AANLkTin_PfbjMuye6J3dD7VrF3PYPhfA3up-+vuaBk-R@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin_PfbjMuye6J3dD7VrF3PYPhfA3up-+vuaBk-R@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My patches don't change nothing else but ksymtab* and kcrctab*
> entries. My intentions were to leave actual symbols completely
> unchanged.

Your patches are fine because they're for modules. I just said the same trick 
would not work for the main kernel ksymtab. Sorry for the confusion.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
