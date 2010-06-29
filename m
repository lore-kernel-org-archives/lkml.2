Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0F2TD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:03:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52883 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0F2TDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=YGDhyGSYYfMfQVZoxxhJX38VPrtQCuUzPM0wHzZIAu3fG4ZlrhXy3KjI7m0BXoN8Z2
         QYMzP2gtyUHpeKFhP6yiKuH5wyYKGUTPl0ilJUmGq5eY6MfMHlfsJU1VVfWNAs9b4qKT
         XgesX8sbJyMRGcHiSERNezQI5kxIS/wLilrUk=
Date: Tue, 29 Jun 2010 21:01:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/25] r852: remove casts from void*
Message-ID: <20100629190132.GP19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	Kernel Janitors <kernel-janitors@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <1277806498-30738-1-git-send-email-segooon@gmail.com> <20100629123850.GO19184@bicker> <20100629152823.GA4268@shinshilla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629152823.GA4268@shinshilla>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 07:28:26PM +0400, Kulikov Vasiliy wrote:
> > 1) The subjects are not helpful.  This one should say something about
> > "mtd" but it doesn't.
> ok
> 
> > 2) These haven't been run through checkpatch.pl.
> Sorry for dummy question, but shouldn't code style be consistent?
> Somebody who will see old code and patched code will see one line with
> wrong-style code then one line with ok then one with wrong etc.
> Imho it's better to fix style in one big patch.

No.  If there's only one good line in a whole file, that's at least
better than nothing.

regards,
dan carpenter

