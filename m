Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2EQHcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:32:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59567 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759523Ab2EQHcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:32:53 -0400
Message-ID: <1337239966.2926.1.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/5] st: Use static class attributes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kai.makisara@kolumbus.fi, jeffm@suse.com
Date: Thu, 17 May 2012 08:32:46 +0100
In-Reply-To: <4FB4782F.9080907@suse.com>
References: <4FB476DD.4020107@suse.com> <4FB4782F.9080907@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 21:01 -0700, Lee Duncan wrote:
> Sorry. This is actually
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> 
> Apologies. The other patches in the set are labeled correctly.

Actually, no, in this case, I need a From: field at the top as well for
the author.

You obviously used git to generate them, so either

git show --pretty=email

or

git format-patch -k

Will produce the right form

James


