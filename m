Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2FFLgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:36:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33167 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FFLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:36:12 -0400
Message-ID: <1338982637.3292.63.camel@lappy>
Subject: Re: [PATCH 05/11] mm: frontswap: split frontswap_shrink further to
 eliminate locking games
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad@darnok.org
Cc: linux-mm@kvack.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, dan.magenheimer@oracle.com
Date: Wed, 06 Jun 2012 13:37:17 +0200
In-Reply-To: <CAPbh3ruJVJkemK4WqjxQYbXYtD9zdDB3dqrRF916cpw3Ub66ug@mail.gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
	 <1338980115-2394-5-git-send-email-levinsasha928@gmail.com>
	 <CAPbh3ruJVJkemK4WqjxQYbXYtD9zdDB3dqrRF916cpw3Ub66ug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:30 -0400, Konrad Rzeszutek Wilk wrote:
> 
> On Jun 6, 2012 6:55 AM, "Sasha Levin" <levinsasha928@gmail.com> wrote:
> >
> > Split frontswap_shrink to eliminate the locking issues in the
> original code.
> 
> Can you describe the locking issue please?

I may have worded that wrong, it's less of an "issue" and more of a
complicated code to deal with locking, specifically the extra local
variable to keep track whether we are locking or not.

