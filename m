Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1KBXEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:04:39 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:31686 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1KBXEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:04:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jesper Juhl <jj@chaosbits.net>, Dan Carpenter <dan.carpenter@oracle.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>, "gregkh@suse.de" <gregkh@suse.de>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "joe@perches.com" <joe@perches.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Topic: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Thread-Index: AQHMlb5tFmjUXJbXLkiQVEJ5ygNb75WS0voAgAB//gCAB1z8gP//i9tw
Date: Wed, 2 Nov 2011 23:04:37 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA5DAF3@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1110290041500.31615@swampdragon.chaosbits.net>
 <20111029063240.GH14881@longonot.mountain>
 <alpine.LNX.2.00.1111022353530.20903@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111022353530.20903@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Wednesday, November 02, 2011 6:59 PM
> To: Dan Carpenter
> Cc: KY Srinivasan; dmitry.torokhov@gmail.com; jkosina@suse.cz;
> gregkh@suse.de; ohering@suse.com; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org; joe@perches.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> 
> On Sat, 29 Oct 2011, Dan Carpenter wrote:
> 
> > On Sat, Oct 29, 2011 at 12:54:34AM +0200, Jesper Juhl wrote:
> > > > +			default:
> > > > +				pr_err("unhandled packet type %d, tid %llx len
> %d\n",
> > > > +				   desc->type,
> > > > +				   req_id,
> > > > +				   bytes_recvd);
> > >
> > > Why not:
> > >
> > >                                 pr_err("unhandled packet type %d, tid %llx
> > >                                        len %d\n", desc->type, req_id, bytes_recvd);
> >
> > Because then the printk would be messed up?  Your final printed
> > string would look like:
> >
> > "unhandled packet type %d, tid %llx
> >                                        len %d\n"
> >
> > Don't break strings up across lines because it breaks grep.  If K. Y.
> > wants to put all the parameters on one line instead of three that
> > would probably be better, but in the end who cares?
> >
> Right, so I obviously "fat fingered" that and should have read my email
> once more before sending. *But* the point really was just the "put all the
> parameters on one line rather than 3" bit...
> 
> As for who cares; well, I cared enough to actually read the patch and send
> a reply, and I thought we needed more reviewers... When I review something
> I comment on everything I spot from bugs to trivial stuff - then it is
> up to the recipient to pick the things they want to address from the
> reply..

I am sure I will have to re-spin this. I will take care of it then.


Regards,

K. Y
 

