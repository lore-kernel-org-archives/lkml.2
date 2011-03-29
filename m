Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1C2NWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1C2NWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:22:20 -0400
Date: Tue, 29 Mar 2011 09:22:16 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Steven Hardy <shardy@redhat.com>
Cc: Greg KH <gregkh@suse.de>, mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH 2/3 (2nd draft)] Resend : Fix memory leak in qcserial
 driver
Message-ID: <20110329132216.GS2526@redhat.com>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328142148.GA19521@suse.de>
 <20110328221636.GA8195@shardy.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328221636.GA8195@shardy.csb>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:16:37PM +0100, Steven Hardy wrote:
> +	/* Set serial->private if not returning -ENODEV */
> +	if ( retval != -ENODEV )
            ^                 ^
coding style
> +		usb_set_serial_data(serial, data);
>  	return retval;
>  }
the rest looks good to me.

-- 
Aristeu

