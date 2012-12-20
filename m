Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2LTINC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:13:02 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40252 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2LTIM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:12:56 -0500
Date: Thu, 20 Dec 2012 02:12:46 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH RESEND] Documentation: kernel-parameters.txt remove
 capability.disable
To: Josh Boyer <jwboyer@redhat.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>, akpm@linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20121218172500.GC19265@hansolo.jdub.homelinux.org>
In-Reply-To: <20121218172500.GC19265@hansolo.jdub.homelinux.org> (from
	jwboyer@redhat.com on Tue Dec 18 11:25:01 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1355991166.24099.18@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 11:25:01 AM, Josh Boyer wrote:
> Remove the documentation for capability.disable.  The code supporting  
> this
> parameter was removed with:
> 
> 	commit 5915eb53861c5776cfec33ca4fcc1fd20d66dd27
> 	Author: Miklos Szeredi <mszeredi@suse.cz>
> 	Date:   Thu Jul 3 20:56:05 2008 +0200
> 
>     	security: remove dummy module
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Acked-by: Rob Landley <rob@landley.net>

Could you send it through trivial@kernel.org please?

Rob