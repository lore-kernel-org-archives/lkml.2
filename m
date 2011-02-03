Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1BCCru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:47:50 -0500
Received: from kroah.org ([198.145.64.141]:56978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1BCCrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:47:49 -0500
Date: Wed, 2 Feb 2011 18:48:49 -0800
From: Greg KH <greg@kroah.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: A problem about linux/Documentation/SubmittingPatches
Message-ID: <20110203024849.GA16029@kroah.com>
References: <20110202174531.GA7717@gmail.com>
 <20110202124633.e2380a77.rdunlap@xenotime.net>
 <20110202205352.GA29053@kroah.com>
 <AANLkTikPM3m4D=qdzA0SHQG4J+ukH5jYSHC8zEMj_oH=@mail.gmail.com>
 <20110203024410.GA2564@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203024410.GA2564@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 10:44:11AM +0800, Harry Wei wrote:
> On Thu, Feb 03, 2011 at 10:27:47AM +0800, harryxiyou wrote:
> > ---------- Forwarded message ----------
> > From: Greg KH <greg@kroah.com>
> > Date: Wed, 2 Feb 2011 12:53:52 -0800
> > Subject: Re: A problem about linux/Documentation/SubmittingPatches
> > To: Randy Dunlap <rdunlap@xenotime.net>
> > Cc: Harry Wei <harryxiyou@gmail.com>, linux-kernel@vger.kernel.org,
> > akpm@linux-foundation.org
> > 
> > On Wed, Feb 02, 2011 at 12:46:33PM -0800, Randy Dunlap wrote:
> > > On Thu, 3 Feb 2011 01:45:32 +0800 Harry Wei wrote:
> > >
> > > > Hi us,
> > > >    I have seen linux-2.6.7/Documentation/SubmittingPatches but it hasn't described how to submit a translated document to kernel. I have also sent mail to <linux-kernel@zh-kernel.org>, however, there is no response.
> > > >    I have translated linux-2.6.37/Decumentation/SecurityBugs(no one translated it up to now). I'd like to send it to maintainers, then add it into kernel directories. However, I don't know how i can do it. Can anyone tell me howto do it? Thanks so much :)
> > >
> > > Hi,
> > >
> > > AFAIK, Greg KH handles all of the translation merging.
> > >
> > > Right, Greg?
> > 
> > Yes, please feel free to send me any translations in patch form and I
> Patch form? There is no patch form for translation document in kernel
> directories. Following is my translation document(for
> linux-2.6.37/Documentation/SecurityBugs). I have translated
> it(linux-2.6.37/Documentation/SecurityBugs) into Chinese.

No, you need to send me a patch, as described in
Documentation/SubmittingPatches that adds the file to the kernel source
tree.  That's the only way we can apply it, and is what I have done for
all of the other translated files in the kernel.

thanks,

greg k-h
