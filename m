Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1ADQoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:44:17 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:34411 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab1ADQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:44:16 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291590000"; 
   d="scan'208";a="85322362"
Date: Tue, 4 Jan 2011 17:44:14 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        joe@perches.com
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
Message-ID: <20110104164414.GX5875@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dan Carpenter <error27@gmail.com>,
	Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, joe@perches.com
References: <20110104055900.GA5062@bicker> <20110104163836.GA30317@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110104163836.GA30317@fieldses.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields, le Tue 04 Jan 2011 11:38:36 -0500, a écrit :
> On Tue, Jan 04, 2011 at 08:59:00AM +0300, Dan Carpenter wrote:
> > This patch makes checkpatch.pl complain if you break up conditions in
> > the wrong way.
> > 
> > Wrong:
> > 	if ((really_long_condition)
> > 		&& (second_condition)) { ...
> > Right:
> > 	if ((really_long_condition) &&
> > 		(second_condition)) { ...
> 
> As far as I can tell, the convention in mathematical typesetting is to
> put operators on the left, not the right.  When the conditions are short
> of there are more lines, that allows you to left-align on the repeated
> operator.

I personnally find the left approach more readable.

Samuel
