Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0KRBdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:33:38 -0500
Received: from kroah.org ([198.145.64.141]:35500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0KRBc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:56 -0500
Date: Wed, 17 Nov 2010 17:24:44 -0800
From: Greg KH <greg@kroah.com>
To: David Brown <davidb@codeaurora.org>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20101118012444.GB7710@kroah.com>
References: <1289916492-28402-1-git-send-email-tlinder@codeaurora.org> <20101117213535.GD10541@kroah.com> <20101118001224.GA19942@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118001224.GA19942@huya.qualcomm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:12:24PM -0800, David Brown wrote:
> On Wed, Nov 17, 2010 at 01:35:35PM -0800, Greg KH wrote:
> 
> > Does your lawyers agree that this is correct to add based on the size of
> > the file?  Hint, it doesn't pass the rule that some lawyers I work with
> > go by, so I would be surprised that it passes theirs.
> 
> The guideline I've been giving people is to not add a Code Aurora
> copyright unless we change a very significant portion of the file.

This patch does not cover that "significant portion" ruling that
copyright lawyers like to base things by.  Please work with your lawyers
if you have questions about this as I can't accept it as-is.

> > Also, I didn't think that "Code Aurora Forum" was a "real" legal entity
> > last time I looked, so how can it own copyrights?  Who is the "real"
> > owner here?  (hint, who does your lawyers work for...)
> 
> The copyrights are assigned to the Code Aurora Forum.

But that's not the employer, which is the issue.  See my other response
for details.

thanks,

greg "I spend too much time with lawyers" k-h
