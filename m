Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2LDN63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:58:29 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:50945 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613Ab2LDN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:58:25 -0500
Message-ID: <1354629480.475.7.camel@thor>
Subject: Re: [PATCH -next 0/9] tty: Fix buffer work access-after-free
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Ilya Zykov <ilya@ilyx.ru>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 08:58:00 -0500
In-Reply-To: <20121204085426.389ca79b@bob.linux.org.uk>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
	 <20121204085426.389ca79b@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 08:54 +0000, Alan Cox wrote:
> On Tue,  4 Dec 2012 02:07:36 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
> 
> > This patch series addresses the causes of flush_to_ldisc accessing
> > the tty after freeing.
> 
> Looks good to me. Would be nice to keep a copy of the test that shows
> it up in the comments of the patches somewhere.

I assume you mean somewhere other than ml archives:
https://lkml.org/lkml/2012/12/1/57

Setting up a mini-testsuite is good idea. As I noted in that email
though, that test jig is a derivative work that I'd want a ok from Ilya
Zykov to put somewhere more permanent.

Regards,
Peter Hurley

