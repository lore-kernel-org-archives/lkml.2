Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1KWW2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:28:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab1KWW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:28:34 -0500
Date: Wed, 23 Nov 2011 12:29:12 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] samsung-laptop: add true rfkill support for swsmi
Message-ID: <20111123202912.GA1355@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-13-git-send-email-corentincj@iksaif.net>
 <20111122222457.GL24283@suse.de>
 <CAHR064hUBJWpJL-jeqAEANnd-fZgBQCHrczwAbV0Tsy-0tUTXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064hUBJWpJL-jeqAEANnd-fZgBQCHrczwAbV0Tsy-0tUTXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 07:37:17AM +0100, Corentin Chary wrote:
> On Tue, Nov 22, 2011 at 11:24 PM, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Nov 22, 2011 at 11:02:43PM +0100, Corentin Chary wrote:
> >> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> >
> > What happens on machines that don't support this?
> 
> As I understand things, SwSMI == SABI3, and it looks a very clear and
> stable interface. My guess is that all SABI3 machines support this
> command. If it is not the case, swsmi_wireless_status() will fail, and
> rfkill won't be created.

Ok, that sounds good.

greg k-h
