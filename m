Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2CAAXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:23:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36007 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab2CAAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:23:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.219.130 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Wed, 29 Feb 2012 15:58:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make a bus with heterogeneous devices?
Message-ID: <20120229235811.GA29287@kroah.com>
References: <20120224152051.GA23232@mail.gnudd.com>
 <20120225004008.GA3973@kroah.com>
 <3271851.0Q0oftP0IB@harkonnen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3271851.0Q0oftP0IB@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 02:57:01PM +0100, Federico Vaga wrote:
> > I think you need to look at how the system bus is handled.  It just went
> > into 3.3-rc and allows for "different" types of devices to all be on the
> > same bus, with different drivers and attributes.  Let me know if how
> > that works does not work out for you.
> 
> Can I have a reference to the patch(s) which introduces this? 
> I taked a look (3.3-rc5) but I didn't find it

Look at ca22e56debc57b47c422b749c93217ba62644be2 and the patches after
it.

Hope this helps,

greg k-h
