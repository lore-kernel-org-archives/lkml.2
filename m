Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1KCMiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:38:20 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:33497 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab1KCMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:38:18 -0400
Message-ID: <4EB28B37.8030301@de.ibm.com>
Date: Thu, 03 Nov 2011 13:38:15 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Rusty Russell <rusty@ozlabs.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Joe Perches <joe@perches.com>,
        Miche Baker-Harvey <miche@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH] VirtioConsole support.
References: <20111027173527.GA23839@phenom.dumpdata.com> <1319751802-27013-1-git-send-email-miche@google.com> <1319770558.2529.20.camel@Joe-Laptop> <4EAAF23C.8050102@codeaurora.org> <87k47itc7u.fsf@rustcorp.com.au>
In-Reply-To: <87k47itc7u.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/11 23:02, Rusty Russell wrote:
> Ben, Christian, can you figure out what's going on?  Is it time for a
> complete rewrite?

You are talking about hvc console? Yes it has so many users that it is now
something like a console/tty layer extension, but it was never designed to be
one. 

I think the hardest part would be to get all users together (for testing and
requirements) and then to find someone that is actually doing that rework. Dont
know if the pain level is already that high?

Christian
