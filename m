Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1CYOku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:40:50 -0400
Received: from kroah.org ([198.145.64.141]:53247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab1CYOkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:40:49 -0400
Date: Fri, 25 Mar 2011 07:40:42 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.32.35
Message-ID: <20110325144042.GA13981@kroah.com>
References: <20110324151649.GA635@kroah.com>
 <AANLkTik7sftrrx9dfmpGyzpek_YDjUjfsPWE5AdpQiWc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik7sftrrx9dfmpGyzpek_YDjUjfsPWE5AdpQiWc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:31:30PM +0300, Alexander Beregalov wrote:
> On 24 March 2011 18:16, Greg KH <gregkh@suse.de> wrote:
> > I'm announcing the release of the 2.6.32.35 kernel.
> 
> It is not available in linux-2.6-allstable tree.
> v2.6.32.28 is the last tag for 2.6.32.x releases.

That is because the script that creates that tree isn't pulling from the
longterm trees, sorry.

greg k-h
