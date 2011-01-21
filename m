Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1AUXdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:33:38 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42854 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1AUXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ca/YxcmAOsOgVWPK8Uht7Jvqh+0TmLFqR6XfwzzP/VANiC5n8Lt5O2/lxx/kOmqoow
         Z/E/iKti3AfNb+pvS4ZNbJPkY/6kg6DziIhLPE22ZB/AuEXEXp5XAST6O8aKyQfJutWL
         42gkqNEVq3YlXsRtX/FTGCbWc8yhHPOqS8zAk=
Date: Fri, 21 Jan 2011 15:33:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 2/2] staging: synaptics: Implement error hamdling for
 rmi4 touch regulator
Message-ID: <20110121233329.GB27943@core.coreip.homeip.net>
References: <1295605236-3031-1-git-send-email-naveen.gaddipati@stericsson.com>
 <20110121203815.GA25099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121203815.GA25099@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:38:15PM -0800, Greg KH wrote:
> On Fri, Jan 21, 2011 at 03:50:36PM +0530, Naveen Kumar G wrote:
> > From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > 
> > Implement the error handling for regulator in synaptics
> > rmi4 touch screen
> > 
> > Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> 
> This patch has some fuzz and doesn't apply correctly.  Care to rediff it
> and resend it?
> 

Given that this driver is a [hopefully] dead-end placeholder should we
even spend time cleaning this up? It would be better if effor was spent
helping Synaptics folks clean up their generic driver...

Thanks.

-- 
Dmitry
