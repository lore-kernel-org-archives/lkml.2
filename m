Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1AGGGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:06:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61287 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1AGGGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:06:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Nur3IDTf5+Zv6CcRdQ4IccrcSInyIbvtreSItS/lbYGPcnxe9xFdZFxpWFXBXZpuOZ
         UqbrWYRmZrt1YBL4FngjHCOZC8gpJ6hmp6NyjC9zSAKsgfRTp48rGx0RwBTc5jIyxjOe
         +RlEApJngrKfrqlBpi2BmtFnFLN4tffszpTOU=
Date: Fri, 7 Jan 2011 09:05:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] vga_switcheroo: comparing too few characters in
 strncmp()
Message-ID: <20110107060558.GE1717@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110107051227.GD1717@bicker>
 <20110107053054.GA9057@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107053054.GA9057@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 07:30:54AM +0200, Alexey Dobriyan wrote:
> On Fri, Jan 07, 2011 at 08:12:27AM +0300, Dan Carpenter wrote:
> > -	if (strncmp(usercmd, "MDIS", 3) == 0) {
> > +	if (strncmp(usercmd, "MDIS", 4) == 0) {
> 
> How about you NUL-terminate, and use strcmp().

I assume there is a reason for this userspace API.  Dave?

regards,
dan carpenter
