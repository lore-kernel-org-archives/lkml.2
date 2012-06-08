Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab2FHTBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:01:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50508 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2FHTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:01:41 -0400
Message-ID: <4FD246C2.1040105@landley.net>
Date: Fri, 08 Jun 2012 13:38:58 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Jozsef Marton <jmarton@users.sourceforge.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        torvalds@linux-foundation.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH] Documentation: removed media from linux/Documentation/dontdiff
 to include changes under drivers/media
References: <4FB27CC6.3050500@users.sourceforge.net> <4FCFC7C3.3080603@users.sourceforge.net>
In-Reply-To: <4FCFC7C3.3080603@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 04:12 PM, Jozsef Marton wrote:
> From: Jozsef Marton <jmarton@users.sourceforge.net>
> 
> Dontdiff patterns in linux/Documentation/dontdiff used to include media, so "diff -uprN -X linux/Documentation/dontdiff ..." as suggested to be used in linux/Documentation/SubmittingPatches did not examine changes under linux/drivers/media. Pattern has been removed.
> 
> Signed-off-by: Jozsef Marton <jmarton@users.sourceforge.net>

Acked-by: Rob Landley <rob@landley.net>

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
