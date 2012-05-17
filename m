Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276Ab2EQHfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:35:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59581 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105Ab2EQHfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:35:34 -0400
Message-ID: <1337240130.2926.4.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 3/5] st: get rid of scsi_tapes array
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kai.makisara@kolumbus.fi, jeffm@suse.com
Date: Thu, 17 May 2012 08:35:30 +0100
In-Reply-To: <4FB476F3.5010404@suse.com>
References: <4FB476F3.5010404@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 20:56 -0700, Lee Duncan wrote:
> st currently allocates an array to store pointers to all of the
> scsi_tape objects. It's used to discover available indexes to use as the
> base for the minor number selection and later to look up scsi_tape
> devices for character devices.
> 
> We switch to using an IDR for minor selection and a pointer from
> st_modedef back to scsi_tape for the lookups.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>

This can't be Reviewed-by either.  The signoff chain has to follow the
transmission path of the patch.  If you send me Jeff's patches, you have
to add a signoff because you're a direct part of the transmission path.
If Jeff sends me them, then he can give you Reviewed-by because you're
not then in the direct transmission path.  (Signoff is supposed to imply
reviewed by anyway, so the tagging is correct in either case).

James


