Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0JHS1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:27:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65383 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0JHS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QP+sa5T8YhzrBRCScpDisBE3gsMyXXwSTt9kPQRtpet0AQv2z6ronrCtMRTtiMNO3P
         a2SCSvoBpJap+aZJh6azjzdBqoI5e59ufkBWpodmdl/3P2OMUj8eNd/bwtnq4kDC+tyi
         0LyK5AqI353rQGPKaWeiYE1gUTeOb5PKO7Yzc=
Date: Fri, 8 Oct 2010 22:27:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] apic, x86: Use BIOS settings for IBS and MCE
	threshold interrupt LVT offsets
Message-ID: <20101008182713.GA5780@lenovo>
References: <1286360874-1471-1-git-send-email-robert.richter@amd.com> <1286360874-1471-3-git-send-email-robert.richter@amd.com> <20101006194150.GA17647@lenovo> <20101008092452.GE13563@erda.amd.com> <AANLkTi=6O1nUC71OiwcJBjmH-naq3ofMXyA0BqoT7Q55@mail.gmail.com> <20101008102115.GG13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101008102115.GG13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 12:21:15PM +0200, Robert Richter wrote:
> On 08.10.10 05:37:24, Cyrill Gorcunov wrote:
> > On Fri, Oct 8, 2010 at 1:24 PM, Robert Richter <robert.richter@amd.com> wrote:
> > ...
> > >> > +                   } else if (lvt_off != offset) {
> > >>
> > >> Could we put explicit type specificator here? For better readbility.
> > >> ...
> > >
> > > Cyrill,
> > >
> > > Do you mean an explicit type cast here, or something else?
> > >
> > 
> > Yeah, explicit type cast (not a big deal though since at moment
> > of course nothing can fire in this snippet, but I think for future
> > modifications better to have explicit cast).
> 
> Hmm, don't think this is really necessary. As an alternative we could
> make variable offset an int too and then do an explicit cast when
> calling setup_APIC_eilvt().
> 
> But I rather tend to leave it as it is.

Well, I don't insist at all. Lets leave it as is.

  Cyrill
