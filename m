Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1IUTTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:19:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50155 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab1IUTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:19:20 -0400
X-Sasl-enc: HTfFhg4Mvzfz0i7z/wFQXIcBJrSZjZzwLxzHhVilRwL4 1316632759
Date: Wed, 21 Sep 2011 12:18:56 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        richard@nod.at, Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: usb: make usb urbs user namespace aware
 (v2)
Message-ID: <20110921191856.GA30859@kroah.com>
References: <20110919214531.GA18085@sergelap>
 <20110919214700.GA22300@sergelap>
 <20110920131738.GA29852@redhat.com>
 <20110921050127.GB6691@sergelap>
 <20110921183101.GB25590@redhat.com>
 <20110921191238.GA16720@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921191238.GA16720@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 02:12:38PM -0500, Serge E. Hallyn wrote:
> 
> Drat.  Greg, sorry about not Cc:ing you on the original patch.  Please
> let me know if you'd like me to resend to you.

Please do, and cc: linux-usb@vger.kernel.org as I have no idea what you
are referring to here at all.

thanks,

greg k-h
