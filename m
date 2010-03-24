Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0CXK0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:26:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38911 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab0CXK0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:26:51 -0400
Date: Wed, 24 Mar 2010 12:26:00 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Dan Carpenter <error27@gmail.com>, Felipe Balbi <felipe.balbi@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ajay Kumar Gupta <ajay.gupta@ti.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] musb: potential use after free
Message-ID: <20100324102600.GP29419@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20100320122403.GC5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100320122403.GC5331@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 Mar 2010 10:26:25.0108 (UTC) FILETIME=[74C5D940:01CACB3C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 01:24:03PM +0100, ext Dan Carpenter wrote:
>We assign "urb->hcpriv = qh;" a few lines down.  I'm pretty sure we
>want it "urb->hcpriv" to be NULL not a freed value.
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>

applied, thanks

-- 
balbi
