Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0KBODv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:03:51 -0400
Received: from kroah.org ([198.145.64.141]:38981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0KBODr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:03:47 -0400
Date: Tue, 2 Nov 2010 07:03:37 -0700
From: Greg KH <greg@kroah.com>
To: Naveen Kumar G <naveen.gaddipati@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Message-ID: <20101102140337.GC9387@kroah.com>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:38:45PM +0530, Naveen Kumar G wrote:
> --- /dev/null
> +++ b/drivers/staging/ste_rmi4/TODO
> @@ -0,0 +1,7 @@
> +TODO
> +----
> +
> +Wait for the official upstream synaptics rmi4 clearpad drivers as promised over the past few months
> +Merge any device support needed from this driver into it
> +Delete this driver

Huh?

Why not just add this driver to the kernel tree instead?  When the
"promised" driver then eventually shows up (who is promising it?) then
delete the thing.

But until then, why is this needed to go into the staging tree?  Is
there any other main reason it should be here and not in the "real" part
of the kernel?

thanks,

greg k-h
