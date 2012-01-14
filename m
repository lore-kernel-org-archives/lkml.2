Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2ANVwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:52:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab2ANVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:52:31 -0500
Subject: Re: [PATCH] scripts/coccinelle: improve the coverage of some
 semantic patches
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Jan 2012 23:52:25 +0200
In-Reply-To: <1326577096.2172.2.camel@koala>
References: <1326562543-8448-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1326577096.2172.2.camel@koala>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326577949.2172.5.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-14 at 23:38 +0200, Artem Bityutskiy wrote:
> On Sat, 2012-01-14 at 18:35 +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > This patch ensures that all semantic patches in the scripts/coccinelle
> > directory provide the report option.  Report messages that include line
> > numbers now have the line number preceded by "line" for easier subsequent
> > processing.
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Julia, thanks a lot for this harmonization effort!
> 
> I did not do detailed review, but looks good.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Adding Michal to "To:", since you apparently merge via his tree. Michal,
would you please pick this one as well?

Artem.

